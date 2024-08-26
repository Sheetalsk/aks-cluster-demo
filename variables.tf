variable "resource_group_name" {
    type = string
    description = "resource group name"
}

variable "location" {
    type = string
    default = "malaysiawest"
}

variable "cluster_name" {
    type = string
}

variable "ssh_key_name" {
   type = string
}

variable "storage_account_name" {
   type = string
}

variable "container_registry_name" {
  type = string
}

variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number
}