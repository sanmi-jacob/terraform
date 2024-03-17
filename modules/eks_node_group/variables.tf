variable "node_group_name" {}

variable "tags" {}


variable "subnet_id" {}

variable "instance_type" {
    type = list(string)
}

variable "instance_disk_size" {}

variable "ec2_ssh_key" {}

variable "security_group_id" {
    type = list
}

variable "cluster_name" {}

//variable "launch_template_id" {}

//variable "launch_template_version" {}

variable "capacity_type" {
    default = "ON_DEMAND"
}
variable "desired_size" {
    default = 1
}
variable "min_size" {
    default = 1
}
variable "max_size" {
    default = 20
}

variable "max_unavailable_percentage" {
    default = 50
}


variable "env" {

}

variable "node_iam_role" {
  
}