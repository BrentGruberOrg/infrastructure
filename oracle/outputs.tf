output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.this.availability_domains
}