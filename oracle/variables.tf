variable "tf_org" {
  description = "Name of the Terraform organization to use for the backend"
  type        = string
  default     = "BrentGruberOrg"
}

variable "tf_workspace" {
  description = "Name of the Terraform workspace to use for the backend"
  type        = string
  default     = "oracle-cloud-compute"
}


# Oracle Cloud variables
variable "TENANCY_OCID" {
  description = "OCID of the tenancy"
  type        = string
}

variable "USER_OCID" {
    description = "OCID of the user"
    type        = string
}

variable "FINGERPRINT" {
    description = "FINGERPRINT of API key in OCI"
    type        = string
}

variable "REGION" {
    description = "OCI REGION"
    type        = string
    default     = "us-chicago-1"
}

variable "PRIVATE_KEY" {
    description = "OCI Private key"
    type        = string
}

variable "SSH_KEY" {
    description = "SSH Key for instance"
    type        = string
}

variable "name" {
  description = "Display name for resources"
  type        = string
  default     = "OCI Free Compute Maximal"
}

variable "cidr_block" {
  description = "CIDR block of the VCN"
  type        = string
  default     = "10.10.10.0/24"

  validation {
    condition     = can(cidrsubnets(var.cidr_block, 2))
    error_message = "The value of cidr_block variable must be a valid CIDR address with a prefix no greater than 30."
  }
}

# variable "ssh_public_key" {
#   description = "Public key to be used for SSH access to compute instances"
#   type        = string
# }