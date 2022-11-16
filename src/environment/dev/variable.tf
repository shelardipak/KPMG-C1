variable "pe_name" {
  description = "Name of the private endpoint"
  type        = string 
}

variable "resource_group" {
  description = "Resource group"
  type = object({
    name = string
    location = string
  })
}

variable "dns_rg" {
  description = "Resource Group for Private DNS Zones"
  type        = string 
}

variable "zone_name" {
  description = "DNS Private Zone name"
  type        = string
}

variable "subnet_id" {
  description = "subnet resource ID"
  type        = string 
}

variable "connection_resource_id" {
  description = "Applicable resource ID for PL"
  type        = string 
}

variable "subresource" {
  description = "Private Link sub resource"
  type        = string 
}

variable "tags" {
  description = "private end point tags"
  type        = map(any)
}


