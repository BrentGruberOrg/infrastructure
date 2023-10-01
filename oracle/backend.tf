terraform {
    cloud {
        organization = "BrentGruberOrg"

        workspaces {
            name = "oracle-cloud-compute"
        }
    }

    required_providers {
      oci = {
        source = "oracle/oci"
        version = "~> 4.75.0"
      }
    }
}
