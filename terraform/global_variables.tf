variable "profile" {
  type        = string
  description = "AWS profile used by terraform."
  default = "default"
}
variable "aws_region" {
  type        = string
  description = "AWS region."
}
variable "env" {
  type        = string
  description = "Environment Selector."
  validation {
    condition     = contains(["dev01", "dev02", "dev03", "dev04", "dev05", "qa01", "qa02", "stg", "prod", "local"], var.env)
    error_message = "Valid values for var: env are (dev01,dev02,dev03,dev04,dev05,qa01,qa02,stg,prod,local)."
  }
}
variable "project" {
  type        = string
  description = "Project Name."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resources additional tags."
}
