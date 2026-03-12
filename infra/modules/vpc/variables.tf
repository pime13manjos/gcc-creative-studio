variable "gcp_project_id" { type = string }
variable "gcp_region" { type = string }

# Optional: You can add this if you want to customize the network name later
variable "network_name" {
  type        = string
  description = "The name of the VPC network"
  default     = "creative-studio-vpc"
}