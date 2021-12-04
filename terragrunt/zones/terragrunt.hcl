include "root" {
  path           = find_in_parent_folders()
}

terraform {
  source = "../../zones"
}

inputs = {
  domain_name = "pablosspot.ga"
}