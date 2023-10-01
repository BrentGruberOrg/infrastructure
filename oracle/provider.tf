provider "oci" {
    tenancy_ocid = var.TENANCY_OCID
    user_ocid = var.USER_OCID
    fingerprint = var.FINGERPRINT
    region = var.REGION
    private_key_path = "./id_rsa.pem"
}