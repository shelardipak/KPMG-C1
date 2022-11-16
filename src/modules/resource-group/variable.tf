variable "location" {
    type = string
    default = "UK South" 
}

variable "resource_group_name" {
    type = string
}


variable "tags" {
    type = map(string)
   
}
