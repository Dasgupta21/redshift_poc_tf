terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}
# Configure the AWS Provider
provider "aws" {
    region = "us-west-2"
    access_key = var.AWS_Access_key
    secret_key = var.AWS_Access_Secret
}