provider "aws" {
  region = var.region

  default_tags {
    tags = {
      created_by      = "terraform"
      orchestrated_by = "terragrunt"
      workspace       = terraform.workspace
      stack           = "zones-stack"
    }
  }
}
