provider "oci" {
    tenancy_ocid = var.TENANCY_OCID
    user_ocid = var.USER_OCID
    fingerprint = var.FINGERPRINT
    region = var.REGION
    private_key = var.PRIVATE_KEY
}