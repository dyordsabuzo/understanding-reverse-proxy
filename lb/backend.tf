terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pablosspot"

    workspaces {
      prefix = "lb-reverse-proxy-"
    }
  }
}
