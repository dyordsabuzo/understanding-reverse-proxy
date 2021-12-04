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
    }
}

inputs = {
    instance_id = dependency.ec2.outputs.instance_id
}