variable "aws_region" {
    default = "us-east-1" 
    type        = string
}
variable "project_name" { 
    default = "cicd-demo" 
    type        = string
    }
variable "environment" { 
    default = "dev"
    type        = string
    }
variable "vpc_cidr"  { 
    default = "10.20.0.0/16" 
    type        = string
    }
variable "public_subnet_cidr" { 
    default = "10.20.1.0/24" 
    type        = string
    }
variable "ami_id" { 
    default = "ami-0c02fb55956c7d316"
    type        = string
     }  # Ubuntu us-east-1
variable "instance_type" { 
    default = "t3.micro" 
    type        = string
    }
variable "key_name" { 
    default = "your-key-pair" 
    type        = string
    }
