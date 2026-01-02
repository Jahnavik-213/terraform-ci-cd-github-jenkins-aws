# Zero‑click infrastructure deployment:
1. **Push Terraform changes** to GitHub
2. **GitHub Webhook** auto‑triggers Jenkins
3. **Jenkins Pipeline** runs `terraform plan/apply`
4. **AWS infra updates** automatically

GitHub Push → Webhook → Jenkins Pipeline → Terraform → AWS VPC/EC2/RDS


### Features
- **Auto‑trigger** on Git push/PR
- **Manual approval** for `terraform apply`
- **Plan drift detection**
- **Rollback** via `terraform destroy`
- **S3 backend** for state

## Setup (5 minutes)
### 1. Provision Jenkins EC2 (run once)

Use previous terraform infra or manual EC2 with Jenkins
Jenkins URL: http://<jenkins-ip>:8080

### **2.Jenkins Setup**
1. New Item → Pipeline → OK
2. Paste Jenkinsfile below
3. GitHub project: paste repo URL ✓
4. Build Triggers → "GitHub hook trigger for GITScm polling" ✓
5. Save

### 3. GitHub Webhook
Repo → Settings → Webhooks → Add webhook
Payload URL: http://<jenkins-ip>:8080/github-webhook/
Content type: application/json
Events: Just push events

### 4. Test
- Edit terraform/main.tf (add tag)
- git commit -m "Add new EC2 tag"
- git push → Pipeline triggers automatically!

## Pipeline Behavior
Push to main: Full plan → manual approve → apply

PR: Plan only (comment approval)

Destroy: Parameter action=destroy

## Outputs
VPC ID: vpc-xxx

EC2 IPs: 54.x.x.x, 52.x.x.x

Terraform State: s3://your-state-bucket

## Production Notes
- Use AWS IAM role for Jenkins (not keys)
- S3 backend with DynamoDB locking
- Branch‑based environments (dev/prod)

