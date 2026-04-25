# AWS CloudFormation StackSets Ops Lab

This lab demonstrates a mission-critical governance and provisioning pattern for the **AWS SysOps Administrator Associate**: using CloudFormation to manage standardized infrastructure across multiple targets.

## Architecture Overview

The system implements a centralized governance and deployment model:

1.  **Secure Execution:** An IAM Role for CloudFormation (`cloudformation-execution-role`) provides the necessary identity for service-level resource management.
2.  **Standardized Blueprint:** A YAML CloudFormation template (`governance-bucket.yaml`) defines a compliant, standardized S3 bucket.
3.  **Simulated StackSet:** Terraform manages multiple distinct CloudFormation stacks (`governance-stack-instance-1` and `governance-stack-instance-2`) that deploy the same template with unique parameters.
4.  **Uniform Governance:** All deployed resources share the same compliance tags and configuration, ensuring consistency across environments.

## Key Components

-   **CloudFormation Template:** Reusable YAML infrastructure definition.
-   **CloudFormation Stacks:** Individual deployments of the standardized template.
-   **IAM Execution Role:** Service role with delegated permissions for resource management.
-   **Terraform Automation:** Orchestrates the deployment of multiple stacks to simulate StackSet behavior.

## Prerequisites

-   [Terraform](https://www.terraform.io/downloads.html)
-   [LocalStack](https://localstack.cloud/)
-   [AWS CLI / awslocal](https://github.com/localstack/awscli-local)

## Deployment

1.  **Initialize and Apply:**
    ```bash
    terraform init
    terraform apply -auto-approve
    
```

## Verification & Testing

To test the governance and deployment:

1.  **List Deployed Stacks:**
    ```bash
    awslocal cloudformation list-stacks
    aws cloudformation list-stacks
    
```

2.  **Confirm Standardized Resources:**
    List the S3 buckets to see the standardized naming convention in action:
    ```bash
    awslocal s3 ls
    aws s3 ls
    
```

3.  **Inspect Stack Resources:**
    Verify the tags and configuration for a specific stack instance:
    ```bash
    awslocal cloudformation describe-stack-resources --stack-name governance-stack-instance-1
    aws cloudformation describe-stack-resources --stack-name governance-stack-instance-1
    
```

## Cleanup

To tear down the infrastructure:
```bash
terraform destroy -auto-approve
```

---

💡 **Pro Tip: Using `aws` instead of `awslocal`**

If you prefer using the standard `aws` CLI without the `awslocal` wrapper or repeating the `--endpoint-url` flag, you can configure a dedicated profile in your AWS config files.

### 1. Configure your Profile
Add the following to your `~/.aws/config` file:
```ini
[profile localstack]
region = us-east-1
output = json
# This line redirects all commands for this profile to LocalStack
endpoint_url = http://localhost:4566
```

Add matching dummy credentials to your `~/.aws/credentials` file:
```ini
[localstack]
aws_access_key_id = test
aws_secret_access_key = test
```

### 2. Use it in your Terminal
You can now run commands in two ways:

**Option A: Pass the profile flag**
```bash
aws iam create-user --user-name DevUser --profile localstack
```

**Option B: Set an environment variable (Recommended)**
Set your profile once in your session, and all subsequent `aws` commands will automatically target LocalStack:
```bash
export AWS_PROFILE=localstack
aws iam create-user --user-name DevUser
```

### Why this works
- **Precedence**: The AWS CLI (v2) supports a global `endpoint_url` setting within a profile. When this is set, the CLI automatically redirects all API calls for that profile to your local container instead of the real AWS cloud.
- **Convenience**: This allows you to use the standard documentation commands exactly as written, which is helpful if you are copy-pasting examples from AWS labs or tutorials.
