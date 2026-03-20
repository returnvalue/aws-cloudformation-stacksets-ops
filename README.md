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
    ```

2.  **Confirm Standardized Resources:**
    List the S3 buckets to see the standardized naming convention in action:
    ```bash
    awslocal s3 ls
    ```

3.  **Inspect Stack Resources:**
    Verify the tags and configuration for a specific stack instance:
    ```bash
    awslocal cloudformation describe-stack-resources --stack-name governance-stack-instance-1
    ```

## Cleanup

To tear down the infrastructure:
```bash
terraform destroy -auto-approve
```
