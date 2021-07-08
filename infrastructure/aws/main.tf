provider "aws" {
  region = var.region
  access_key = var.access_key_id
  secret_key = var.access_key_secret
}

terraform {  
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.48.0"
     }
    }
    
}