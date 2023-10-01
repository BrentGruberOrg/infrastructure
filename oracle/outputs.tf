output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.this.availability_domains
}

output "public-ip" {
    value = oci_core_public_ip.this.ip_address
}