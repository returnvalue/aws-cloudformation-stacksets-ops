# AWS provider configuration for LocalStack
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
    elb            = "http://localhost:4566"
    elbv2          = "http://localhost:4566"
    rds            = "http://localhost:4566"
    autoscaling    = "http://localhost:4566"
    events         = "http://localhost:4566"
  }
}

# IAM Role: Identity for CloudFormation service execution
resource "aws_iam_role" "cfn_role" {
  name = "cloudformation-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudformation.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "cfn-execution-role"
    Environment = "SysOps-Lab"
  }
}

# IAM Policy: Grants CloudFormation permission to deploy common governance resources
resource "aws_iam_role_policy" "cfn_policy" {
  name = "cloudformation-execution-policy"
  role = aws_iam_role.cfn_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "iam:*",
          "cloudwatch:*",
          "events:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudFormation Stack 1: Instance of the governance template
resource "aws_cloudformation_stack" "governance_stack_1" {
  name          = "governance-stack-instance-1"
  template_body = file("governance-bucket.yaml")
  iam_role_arn  = aws_iam_role.cfn_role.arn

  parameters = {
    BucketNameSuffix = "instance-1"
  }

  tags = {
    Name        = "governance-stack-1"
    Environment = "SysOps-Lab"
  }
}

# CloudFormation Stack 2: A second instance of the same template
resource "aws_cloudformation_stack" "governance_stack_2" {
  name          = "governance-stack-instance-2"
  template_body = file("governance-bucket.yaml")
  iam_role_arn  = aws_iam_role.cfn_role.arn

  parameters = {
    BucketNameSuffix = "instance-2"
  }

  tags = {
    Name        = "governance-stack-2"
    Environment = "SysOps-Lab"
  }
}

# Outputs: Key identifiers for verifying the simulated StackSet deployment
output "stack_1_id" {
  value = aws_cloudformation_stack.governance_stack_1.id
}

output "stack_2_id" {
  value = aws_cloudformation_stack.governance_stack_2.id
}

output "cfn_role_arn" {
  value = aws_iam_role.cfn_role.arn
}
