variable "workload" {
  type        = string
  description = "(Required) The workload of the resource created."
  default     = "demo"
}

variable "environment" {
  type        = string
  description = "(Required) The environment in which the resources are been created."
  default     = "dev"
}

variable "main_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "eastus2"
}

variable "branch_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "westus2"
}

variable "branch_subscription_id" {

}
variable "branch_tenant_id" {

}

variable "branch_client_id" {

}

variable "branch_client_secret" {

}