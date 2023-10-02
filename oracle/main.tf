locals {
    protocol_number = {
        icmp = 1
        icmpv6 = 58
        tcp = 6
        udp = 17
    }

    shapes = {
        flex : "VM.Standard.A1.Flex",
        micro : "VM.Standard.E2.1.Micro"
    }

    availability_domain_micro = one(
        [
            for m in data.oci_core_shapes.this :
            m.availability_domain
            if contains(m.shapes[*].name, local.shapes.micro)
        ]
    )
}

data "template_file" "user_data" {
    template = "${file("./user-data.yaml.tpl")}"
    vars = {
        tailscale_token = var.TAILSCALE_TOKEN
        doppler_token = var.DOPPLER_TOKEN
    }
}

resource "oci_identity_compartment" "this" {
  compartment_id = var.TENANCY_OCID
  description    = var.name
  name           = replace(var.name, " ", "-")

  enable_delete = true
}

resource "oci_core_vcn" "this" {
  compartment_id = oci_identity_compartment.this.id

  cidr_blocks  = [var.cidr_block]
  display_name = var.name
  dns_label    = "vcn"
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id

  display_name = oci_core_vcn.this.display_name
}

resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id

  display_name = oci_core_vcn.this.display_name

  route_rules {
    network_entity_id = oci_core_internet_gateway.this.id

    description = "Default route"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_default_security_list" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_security_list_id

  dynamic "ingress_security_rules" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      protocol = local.protocol_number.tcp
      source   = "0.0.0.0/0"

      description = "SSH and HTTPS traffic from any origin"

      tcp_options {
        max = port.value
        min = port.value
      }
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"

    description = "All traffic to any destination"
  }
}

resource "oci_core_subnet" "this" {
  cidr_block     = oci_core_vcn.this.cidr_blocks.0
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id

  display_name = oci_core_vcn.this.display_name
  dns_label    = "subnet"
}

resource "oci_core_network_security_group" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id

  display_name = oci_core_vcn.this.display_name
}

resource "oci_core_network_security_group_security_rule" "this" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.this.id
  protocol                  = local.protocol_number.icmp
  source                    = "0.0.0.0/0"
}

data "oci_identity_availability_domains" "this" {
  compartment_id = var.TENANCY_OCID
}

data "oci_core_shapes" "this" {
  for_each = toset(data.oci_identity_availability_domains.this.availability_domains[*].name)

  compartment_id = var.TENANCY_OCID

  availability_domain = each.key
}

data "oci_core_images" "this" {
  compartment_id = oci_identity_compartment.this.id

  operating_system         = "Canonical Ubuntu"
  shape                    = local.shapes.flex
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  state                    = "available"

  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-([\\.0-9-]+)$"]
    regex  = true
  }
}


resource "oci_core_instance" "this" {
  availability_domain = data.oci_identity_availability_domains.this.availability_domains.0.name
  compartment_id      = oci_identity_compartment.this.id
  shape               = local.shapes.flex

  display_name         = "Ubuntu"
  preserve_boot_volume = false

  metadata = {
    ssh_authorized_keys = var.SSH_KEY
    user_data = base64encode(data.user_data)
  }

  agent_config {
    are_all_plugins_disabled = true
    is_management_disabled   = true
    is_monitoring_disabled   = true
  }

  availability_config {
    is_live_migration_preferred = null
  }

  create_vnic_details {
    assign_public_ip = false
    display_name     = "Ubuntu"
    hostname_label   = "bgo1"
    nsg_ids          = [oci_core_network_security_group.this.id]
    subnet_id        = oci_core_subnet.this.id
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }

  source_details {
    source_id               = "ocid1.image.oc1.us-chicago-1.aaaaaaaa7utrjlc7yddvcdqwrzfpkq5ojw5umocqwbnczjmjqojwcakkqerq" # Hardcoding for now
    source_type             = "image"
    boot_volume_size_in_gbs = 100
  }

  lifecycle {
    ignore_changes = [source_details.0.source_id]
  }
}

data "oci_core_private_ips" "this" {
  ip_address = oci_core_instance.this.private_ip
  subnet_id  = oci_core_subnet.this.id
}

resource "oci_core_public_ip" "this" {
  compartment_id = oci_identity_compartment.this.id
  lifetime       = "RESERVED"

  display_name  = oci_core_instance.this.display_name
  private_ip_id = data.oci_core_private_ips.this.private_ips.0.id
}
