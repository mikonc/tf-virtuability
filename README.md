# Terraform Infrastructure Project

This repository contains Terraform configurations for creating and managing AWS infrastructure.

- Resources are prefixed with the terrafornm workspace name you're using.
- Each inputs subdirectory defines variables for different environment. Each environment is using a separate state file.
- You can define new environments by adding additional catalogs in `inputs` and creating `.tfvars` files.

## Project Prerequisites

- Terraform version > 1.6

## Resources

This project creates the following AWS resources:

- VPC
- Public and Private Subnets
- EC2 Instance
- Key Pair and Secret Manager secret
- And other supporting resources

## Workflow

Follow these steps to set up and apply the infrastructure:

1. **Generate IAM Secret Key**
   Generate an IAM secret key and export the necessary variables:

   ```
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   export AWS_DEFAULT_REGION="your_region"
   ```

2. **Create Backend**
   Run the `setup-backend.sh` script to create the backend:

   ```
   ./setup_backend.sh
   ```

   You might need to add execution permissions to the file using:
    ```
   chmod +x ./setup_backend.sh
   ```

3. **Create Terraform Workspace**
   Create a Terraform workspace corresponding to the `inputs` subdirectories. For example for `dev`:

   ```
   terraform workspace new dev
   ```

4. **Plan or Apply Infrastructure**
   To plan the infrastructure changes, provide a path to corresponding inputs for given environment. For example `dev` plan:

   ```
   terraform plan -var-file=../inputs/dev/terraform.tfvars
   ```

   To apply the infrastructure:

   ```
   terraform apply -var-file=../inputs/dev/terraform.tfvars
   ```

## Running tests

Tests are stored in `terraform/tests` directory. In order to run them, navigate to `terraform` directory and run the following command:

   ```
   terraform test
   ```

## Improvements ideas
1. More test coverage, variables validation
2. CI/CD to simplify planning and applying infrastructure
3. Separating EC2 and VPC code for clarity
4. Running tests on existing infrastructure (end-to-end testing), `terratest` is one of possible solutions.
