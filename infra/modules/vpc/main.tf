# 1. The VPC Network
resource "google_compute_network" "main" {
  name                    = "creative-studio-vpc"
  auto_create_subnetworks = false
}

# 2. Subnet for general resources
resource "google_compute_subnetwork" "subnet" {
  name          = "creative-studio-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.main.id
}

# 3. Reserve a Private IP range for Google Managed Services (Cloud SQL)
resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-range2"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

# 4. Establish the Peering Connection (The "Tunnel")
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# 5. Serverless VPC Access Connector (For Cloud Run)
# resource "google_vpc_access_connector" "connector" {
#   name          = "run-sql-connector"
#   region        = var.gcp_region
#   network       = google_compute_network.main.id
#   ip_cidr_range = "10.8.0.0/28" # Must be a unique /28 range
# }