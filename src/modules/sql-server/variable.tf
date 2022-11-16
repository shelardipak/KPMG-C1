variable "sql_server_name" {
    description = ""
    default = ""
    type = string
}

variable "resource_group_name" {
    description = ""
    default = ""
    type = string
}

variable "location" {
    description = ""
    default = ""
    type = string
}

variable "sql_server_version" {
    description = ""
    default = ""
    type = string
}

variable "tags" {
  description = ""
  default = {}
  type = map(string)
}

variable "database_name" {
    description = "list of dbs"
    type = list(any)
  
}

variable "key_vault_id" {
    description = ""
    type = string
}
variable "subnet_id" {
    description = ""
    default = ""
    type = string
}

