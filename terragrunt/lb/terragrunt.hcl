include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../lb"
}

dependency "ec2" {
    config_path = "../ec2"

    mock_outputs = {
        instance_id = "temp_value"
        ec2_security_group_id = "temp_id"
    }
}

dependency "zones" {
    config_path = "../zones"
    mock_outputs = {
        certificate_arn = "fake_arn"
    }
}

inputs = {
    instance_id = dependency.ec2.outputs.instance_id
    certificate_arn = dependency.zones.outputs.certificate_arn
    hosted_zone_id = dependency.zones.outputs.hosted_zone_id
    ec2_security_group_id = dependency.ec2.outputs.ec2_security_group_id
}