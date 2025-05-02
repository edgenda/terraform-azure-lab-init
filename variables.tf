variable "users" {
  description = "Lab participants usernames (split by comma)"
  type        = string
}

variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "tenant_domain" {
  description = "Tenant domain for the users"
  type        = string
}
