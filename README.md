# Terraform To-Do App Workshop

This repo is for the **UTD AWS Cloud Computing Club Workshop**.

## Goal
Deploy a simple **Flask To-Do web app** with a **DynamoDB backend** using **Terraform**.

## Steps

1. Install Terraform + AWS CLI
2. Clone this repo
3. Fill in the missing TODOs in `main.tf` (use Terraform Registry docs!)
4. Deploy infrastructure:

```bash
terraform init
terraform apply
```

5. Get the EC2 Public IP and open:

```
http://<public-ip>:5000
```

6. Add/Delete to-do items 🎉

## Cleanup
Destroy resources after use to avoid charges:

```bash
terraform destroy
```
