terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  // リージョンは 東京 リージョンを指定
  region                   = "ap-northeast-1"
  profile                  = "dev"
  // 作成するリソースの共通タグを指定
  default_tags {
    tags = {
      Project     = "taskfolio"
      Environment = "local"
      ManagedBy   = "terraform"
    }
  }
}