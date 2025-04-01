data "oci_core_image" "ubuntu" {
  image_id = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaa4r2snyxdxvszzveg4hftniknp6geb7rhjtxnhfcn232fbzdsuq3q"
}

module "instance" {
  source = "oracle-terraform-modules/compute-instance/oci"

  instance_count              = 2
  ad_number                   = 2
  compartment_ocid            = var.root_locals.provider_configs.compartment_id
  instance_display_name       = var.root_locals.env_locals.instance_name
  source_ocid                 = data.oci_core_image.ubuntu.image_id
  subnet_ocids                = values({ for k, v in module.vcn.subnet_id : k => v if startswith(k, "public") })
  public_ip                   = "RESERVED"
  ssh_authorized_keys         = "~/.ssh/id_rsa.pub"
  block_storage_sizes_in_gbs  = [100]
  shape                       = "VM.Standard.A1.Flex"
  instance_flex_ocpus         = 2
  instance_flex_memory_in_gbs = 12
}
