terraform {
  backend "remote" {
    organization = "pablosspot"

    workspaces {
      prefix = "cf-reverse-proxy-"
    }
  }
}
