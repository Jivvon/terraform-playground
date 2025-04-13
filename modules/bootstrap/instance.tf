data "oci_core_image" "ubuntu" {
  image_id = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaa4r2snyxdxvszzveg4hftniknp6geb7rhjtxnhfcn232fbzdsuq3q"
}

module "instance" {
  count  = var.create_instance ? 1 : 0
  source = "oracle-terraform-modules/compute-instance/oci"

  instance_count        = 2
  ad_number             = 2
  compartment_ocid      = var.root_locals.provider_configs.compartment_id
  instance_display_name = var.root_locals.env_locals.instance_name
  source_ocid           = data.oci_core_image.ubuntu.image_id
  subnet_ocids          = values({ for k, v in module.vcn.subnet_id : k => v if startswith(k, "public") })
  primary_vnic_nsg_ids = [
    oci_core_network_security_group.ssh.id,
    oci_core_network_security_group.egress_all.id,
    oci_core_network_security_group.tailscale.id,
  ]
  user_data = base64encode(templatefile("${var.git_repo_root}/user-data.tftpl.yaml", {
    tailscale_auth_key = var.root_locals.shared_configs.tailscale_auth_key
  }))
  public_ip                   = "RESERVED"
  ssh_public_keys             = file(var.root_locals.shared_configs.public_key_path)
  block_storage_sizes_in_gbs  = [100]
  shape                       = "VM.Standard.A1.Flex"
  instance_flex_ocpus         = 2
  instance_flex_memory_in_gbs = 12
}
