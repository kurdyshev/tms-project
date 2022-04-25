# Example django-app with deployment to AWS ECS

## Initial Set Up
1. Create AWS IAM user and S3 bucket for Teraform tfstate file.
2. Define enviromental variables with GitHub secrets

**Required:**

|Variable|Description|
|---|---|
|AWS_ACCESS_KEY_ID|AWS access key
|AWS_SECRET_ACCESS_KEY|AWS secret key
|AWS_REGION|AWS region
|S3_BUCKET|S3 bucket for Terraform tfstate file
|S3_KEY|S3 key for Terraform tfstate file
|DB_PASSWORD|RDS database password
|TELEGRAM_TOKEN|Telegram bot token for notifications
|TELEGRAM_TO|Telegram chat ID for notifications

**Optional:**

|Variable|Default value|Description|
|---|---|---|
|DB_NAME|django|RDS database name|
|DB_USERNAME|postgres|RDS database user|
|DJANGO_USERNAME|admin|Django admin user|
|DJANGO_PASSWORD|admin|Django admin password|
|DJANGO_EMAIL|admin@admin.local|Django admin email|

3. Manually run **Terraform** workflow with **apply** options to setup AWS infrastructure
4. Commit to any branch to start **Build** workflow. It starts tests, builds docker image and push it to AWS ECR.
5. Commit (pull request) to main branch for Deployment to AWS ECS.
