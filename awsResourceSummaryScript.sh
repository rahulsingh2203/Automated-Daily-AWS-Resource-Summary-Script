#!/bin/bash

################################################################################
# Author: Rahul Singh
#Date: 02-08-24
#version: 1.0.1
################################################################################

# Set the email address of your manager
MANAGER_EMAIL="enggrahulsingh2203@gmail.com"
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
