# Get Amazon Linux 2 AMI (intentionally outdated OS)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "mongodb" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.mongodb_instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.mongodb.id]
  iam_instance_profile        = aws_iam_instance_profile.mongodb.name
  associate_public_ip_address = true

  user_data = <<-USERDATA
    #!/bin/bash
    # Install MongoDB 4.4 (intentionally outdated)
    cat <<'MONGOEOF' > /etc/yum.repos.d/mongodb-org-4.4.repo
    [mongodb-org-4.4]
    name=MongoDB Repository
    baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
    gpgcheck=1
    enabled=1
    gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
    MONGOEOF

    yum install -y mongodb-org

    # Configure MongoDB to bind to all interfaces
    sed -i 's/bindIp: [IP_ADDRESS]/bindIp: 0.0.0.0/' /etc/mongod.conf

    # Start MongoDB
    systemctl enable mongod
    systemctl start mongod

    # Wait for MongoDB to start
    sleep 10

    # Create user and enable auth
    mongo admin --eval '
      db.createUser({
        user: "wizuser",
        pwd: "wizpassword",
        roles: [{ role: "root", db: "admin" }]
      });
    '

    # Enable authentication
    cat >> /etc/mongod.conf <<'AUTHEOF'

    security:
      authorization: enabled
    AUTHEOF

    systemctl restart mongod
  USERDATA

  tags = {
    Name = "${var.project_name}-mongodb"
  }
}


