variable "project_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_count" {
  type    = number
  default = 2
}
