terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "your-terraform-state-bucket"  # Create manually
    key            = "devops-demo/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"  # Create manually
  }
}
