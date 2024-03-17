variable "env_name" {}

variable "tags" {}

variable "cidrs" {}

variable "type" {
    default = "private"
    type = string
}

variable "vpc_id" {}