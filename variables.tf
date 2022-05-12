variable "region" {
    default = "eu-central-1"
    description = "AWS region"
}

variable "cluster_name_prefix" {
    default = "wyep-k8s"
    description = "Cluster Name"
}

variable "vpc_presets" {
    description = "Cluster VPC Presets"
    default = {
        name = "wyep-k8s-vpc"
        cidr = "10.0.0.0/16"
        private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
        public_subnets_cidr = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    }
}

variable "node_presets" {
    description = "Node Presets"
    default = {
        w_grps = [
            {   
                name = "worker-group-1"
                idx = 1
                instance_type = "t2.small"
                asg_desired_capacity = 2
                sg_cidr_blocks = ["10.0.0.0/8"]
            },
            {
                name = "worker-group-2"
                idx = 2
                instance_type = "t2.medium"
                asg_desired_capacity = 1
                sg_cidr_blocks = ["192.168.0.0/16"]
            }
        ]
        all_w_mgmt_cidr = [
            "10.0.0.0/8",
            "172.16.0.0/12",
            "192.168.0.0/16"
        ]
    }
}

variable "cluster_presets" {
    description = "Cluster Presets"
    default = {
        version = "1.20"
    }
}

variable "gh_user" {}
variable "gh_pat" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

/* LOCALS */
locals {
    cluster_name = "${var.cluster_name_prefix}-${random_string.suffix.result}"

    worker_groups = [
        for w_grp in var.node_presets.w_grps:
            {
                name = w_grp.name
                instance_type = w_grp.instance_type
                additional_security_group_ids = [aws_security_group.w_grp_mgmt[w_grp.idx].id]
                asg_desired_capacity = w_grp.asg_desired_capacity
            }
    ]
}
