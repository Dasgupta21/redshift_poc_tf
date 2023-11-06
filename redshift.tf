resource "aws_redshift_cluster" "my_redshift_cluster" {
  cluster_identifier   = "my-redshift-cluster"
  publicly_accessible = false
  database_name       = var.dbname
  master_username     = var.user
  master_password     = var.password
  node_type           = "ra3.xlplus"
  number_of_nodes     = 2

  skip_final_snapshot = true
  cluster_subnet_group_name = "my-redshift-subnet-group"
  vpc_security_group_ids = [aws_security_group.redshift_security_group.id]

#   vpc_id              = aws_vpc.my_vpc.id
  # Specify the subnet group with your subnet IDs
#   cluster_subnet_group_name = "my-redshift-subnet-group"

  iam_roles = [aws_iam_role.redshift_iam_role.arn]
}

resource "aws_iam_role" "redshift_iam_role" {
  name = "my-redshift-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}
