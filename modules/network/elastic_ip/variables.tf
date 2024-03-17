variable "tags" {}

variable "env_name" {}

variable "name" {
  description = "The resource name and Name tag "
  type        = string
  default     = null
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type = list(string)
  default = [null]
}

variable "instance_id" {
  default = null
}
