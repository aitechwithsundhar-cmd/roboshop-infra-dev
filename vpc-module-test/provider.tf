terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1" # terraform AWS provider version 
    }
  }
}

provider "aws" {
  region = "us-east-1"
}