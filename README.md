# AWS Daily Resource Summary Script

This repository contains a Bash script that automates the process of generating and sending a daily summary of AWS resources to a specified email address. The script provides details about EC2 instances, S3 buckets, RDS instances, Lambda functions, and IAM resources, ensuring you stay updated on your AWS infrastructure.

## Features

- **EC2 Instances**: Lists all instances with their IDs, types, states, and launch times.
- **S3 Buckets**: Lists all S3 buckets in the account.
- **RDS Instances**: Provides details about RDS instances including IDs, engines, statuses, and endpoints.
- **Lambda Functions**: Summarizes Lambda functions with names, runtimes, and last modified dates.
- **IAM Users, Groups, Roles, and Policies**: Comprehensive summary of IAM users, groups, roles, and policies for better security management.

## Technologies Used

- **AWS CLI**: To interact with AWS services and retrieve resource information.
- **Bash Scripting**: To automate the process of data collection and email sending.
- **Mailutils**: To send the summary via email.

## Installation

### Prerequisites

- Ubuntu operating system
- AWS CLI installed and configured
- Mailutils installed

### Steps

1. **Install AWS CLI**
    ```bash
    sudo apt-get update
    sudo apt-get install awscli -y
    ```

2. **Configure AWS CLI**
    ```bash
    aws configure
    ```
    Follow the prompts to enter your AWS Access Key ID, Secret Access Key, region, and output format.

3. **Install Mailutils**
    ```bash
    sudo apt-get install mailutils -y
    ```

4. **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/aws-resource-summary.git
    cd aws-resource-summary
    ```

5. **Make the Script Executable**
    ```bash
    chmod +x aws_resource_summary.sh
    ```

## Usage

1. **Edit the Script**
    - Set the `MANAGER_EMAIL` variable to your manager's email address in the `aws_resource_summary.sh` script.

2. **Run the Script Manually**
    ```bash
    ./aws_resource_summary.sh
    ```
    This will generate the summary and send it to the specified email address.

3. **Set Up a Cron Job**
    - Edit your crontab file to schedule the script to run daily at 6 PM.
    ```bash
    crontab -e
    ```
    - Add the following line to the crontab file:
    ```bash
    0 18 * * * /path/to/aws_resource_summary.sh
    ```
    Replace `/path/to/aws_resource_summary.sh` with the actual path to your script.

## Script Details

```bash
#!/bin/bash

# Set the email address of your manager
MANAGER_EMAIL="manager@example.com"

# Set the subject of the email
EMAIL_SUBJECT="Daily AWS Resource Summary"

# Set the temporary file to store the summary
SUMMARY_FILE="/tmp/aws_resource_summary.txt"

# Get the AWS resource summary
{
    echo "AWS Resource Summary"
    echo "===================="
    echo ""
    echo "EC2 Instances:"
    aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,LaunchTime:LaunchTime}" --output table
    echo ""
    echo "S3 Buckets:"
    aws s3 ls
    echo ""
    echo "RDS Instances:"
    aws rds describe-db-instances --query "DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus,Endpoint:Endpoint.Address}" --output table
    echo ""
    echo "Lambda Functions:"
    aws lambda list-functions --query "Functions[*].{Name:FunctionName,Runtime:Runtime,LastModified:LastModified}" --output table
    echo ""
    echo "IAM Users:"
    aws iam list-users --query "Users[*].{UserName:UserName,UserId:UserId,CreateDate:CreateDate}" --output table
    echo ""
    echo "IAM Groups:"
    aws iam list-groups --query "Groups[*].{GroupName:GroupName,GroupId:GroupId,CreateDate:CreateDate}" --output table
    echo ""
    echo "IAM Roles:"
    aws iam list-roles --query "Roles[*].{RoleName:RoleName,RoleId:RoleId,CreateDate:CreateDate}" --output table
    echo ""
    echo "IAM Policies:"
    aws iam list-policies --query "Policies[*].{PolicyName:PolicyName,PolicyId:PolicyId,CreateDate:CreateDate}" --output table
} > "$SUMMARY_FILE"

# Send the summary via email
mail -s "$EMAIL_SUBJECT" "$MANAGER_EMAIL" < "$SUMMARY_FILE"

# Clean up the temporary file
rm "$SUMMARY_FILE"
