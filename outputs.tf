output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "mongodb_public_ip" {
  value = aws_instance.mongodb.public_ip
}

output "mongodb_private_ip" {
  value = aws_instance.mongodb.private_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backups.id
}

output "s3_bucket_url" {
  value = "https://${aws_s3_bucket.backups.id}.s3.${var.aws_region}.amazonaws.com/"
}

output "ecr_repository_url" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/tasky"
}
