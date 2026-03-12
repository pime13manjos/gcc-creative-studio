resource "random_id" "db_name_suffix" {
  byte_length = 4
}
# 1. Reserve a range of internal IP addresses for Google services
resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_network_id # The ID of your existing VPC
}

# 2. Create the private connection (the "Tunnel")
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# 3. Update your SQL Instance
resource "google_sql_database_instance" "default" {
  name             = "creative-studio-db-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15" # Note: GCP currently supports up to PG 15/16; 18 is not yet GA
  region           = var.region
  project          = var.project_id

  # Ensure the VPC connection is created BEFORE the database
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro" # Adjusted for cost, use your N-2 for production

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network_id
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
  
  deletion_protection = false
}

resource "google_sql_database" "default" {
  name     = var.db_name
  instance = google_sql_database_instance.default.name
  project  = var.project_id
}

resource "google_sql_user" "default" {
  name     = var.db_user
  instance = google_sql_database_instance.default.name
  password = var.db_password
  project  = var.project_id
}