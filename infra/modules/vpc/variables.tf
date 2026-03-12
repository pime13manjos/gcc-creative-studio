variable "project_id" {
  type        = string
  description = "The GCP Project ID where the VPC will be created."
}

variable "region" {
  type        = string
  description = "The region for the subnet and VPC connector (e.g., us-central1)."
}

# Optional: You can add this if you want to customize the network name later
variable "network_name" {
  type        = string
  description = "The name of the VPC network"
  default     = "creative-studio-vpc"
}