resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "zip_files/python.zip"
  layer_name = "python_layer"

  compatible_runtimes = ["python3.9"]
}

data "archive_file" "my_lambda_function" {
  type        = "zip"
  source_file = "hello/lambda.py"
  output_path = "zip_files/lambda_function_payload.zip"
}


resource "aws_lambda_function" "s3_copy_function" {
    filename = "zip_files/lambda_function_payload.zip"
    source_code_hash = data.archive_file.my_lambda_function.output_base64sha256
    function_name = "${var.env_name}_s3_copy_lambda"
    role = "${aws_iam_role.s3_copy_function.arn}"
    handler = "lambda.lambda_handler"
    runtime = "python3.9"
    layers = [aws_lambda_layer_version.lambda_layer.arn]
    
    vpc_config {
    subnet_ids         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_group_ids = [aws_security_group.redshift_security_group.id]
  }


    environment {
        variables = {
            DST_BUCKET = "${var.env_name}-dst-bucket",
            REGION = "${var.aws_region}"
            AWS_Access_key = var.AWS_Access_key
            AWS_Access_Secret = var.AWS_Access_Secret
            dbname = var.dbname
            host = local.redshift_endpoint
            user = var.user
            password = var.password
            tablename = var.tablename
            schemaname = var.schemaname
        }
    }
}
