terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1" # terraform AWS provider version 
    }
  }

  backend "s3" {
    bucket         = "remote-state-techai"
    key            = "remote-demo.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}


provider "aws" {
  region = "us-east-1"
}