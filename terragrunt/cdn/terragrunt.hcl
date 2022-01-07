include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../cdn"
}

dependency "lb" {
    config_path = "../lb"
    mock_outputs = {
        lb_dns_name = "temp_lb_dns"
    }
}

dependency "zones" {
    config_path = "../zones"
    mock_outputs = {
        domain_name = "fake_domain_name"
        hosted_zone_id = "fake_hosted_zone_id"
    }
}

inputs = {
    origin_endpoint = dependency.lb.outputs.lb_dns_name
    domain_name = dependency.zones.outputs.domain_name
    aliases = ["main", "sonarr", "radarr"]
    hosted_zone_id = dependency.zones.outputs.hosted_zone_id
}