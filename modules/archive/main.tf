terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.32.0"
    }
  }
}

variable "compartment_id" {
  type = string
}

data "oci_objectstorage_namespace" "archive" {}

# OCI defaults: private access, Standard tier, encryption, no auto-tiering/versioning.
resource "oci_objectstorage_bucket" "archive" {
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.archive.namespace
  name           = "blog-archive"
}

output "archive" {
  value = {
    namespace = oci_objectstorage_bucket.archive.namespace
    bucket    = oci_objectstorage_bucket.archive.name
  }
}
