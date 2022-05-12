resource "aws_security_group" "w_grp_mgmt" {
    name_prefix = "worker_group_management"
    vpc_id = module.vpc.vpc_id

    for_each = var.node_presets.w_grps

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"

        cidr_blocks = "${each.value.sg_cidr_blocks}"
    }
}


resource "aws_security_group" "all_w_mgmt" {
    name_prefix = "all_worker_management"
    vpc_id = module.vpc.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"

        cidr_blocks = var.node_presets.all_w_mgmt_cidr
    }
}
