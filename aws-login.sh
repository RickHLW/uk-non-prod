aws iam create-group --group-name terraform
aws iam create-user --user-name clouduser
aws iam add-user-to-group --user-name clouduser --group-name terraform
export POLICYARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AdministratorAccess`].{ARN:Arn}' --output text)
aws iam attach-user-policy --user-name clouduser --policy-arn $POLICYARN
aws iam create-access-key --user-name clouduser > clouduser-accesskey.txt
