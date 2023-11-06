output "Source-S3-bucket" {
  value = "${aws_s3_bucket.pocredshiftsourcebucket.id}"
}

output "Destination-S3-bucket" {
  value = "${aws_s3_bucket.pocredshiftdestinationbucket.id}"
}

output "redshift_cluster_endpoint" {
  value = aws_redshift_cluster.my_redshift_cluster.endpoint
}