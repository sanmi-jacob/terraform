variable "enable_cluster_encryption_config" {
  default = true
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}`"
  type        = any
  default = {
    resources = ["secrets"]
  }
}

variable "kms_key_arn" {
  default = ""
}
variable "env" {}

variable "tags" {}


variable "subnet_id" {}

variable "security_group_id" {}

variable "ebs_addon" {
  type = bool
  default = false
}

variable "log_types" {
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}