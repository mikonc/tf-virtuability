# BACKEND

terraform {
  backend "s3" {
    bucket         = "274505879165-eu-west-1-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "274505879165-eu-west-1-terraform-state-locktable"
    encrypt        = true
  }
}
