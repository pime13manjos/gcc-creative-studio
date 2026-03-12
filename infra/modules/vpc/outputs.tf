output "network_id" {
  # Change 'main' to the actual name of your resource in modules/vpc/main.tf
  value = google_compute_network.main.id 
}

output "connector_id" {
  # Change 'connector' to the actual name of your resource in modules/vpc/main.tf
  value = google_vpc_access_connector.connector.id
}