resource "oci_core_network_security_group" "ssh" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "ssh"
}

resource "oci_core_network_security_group_security_rule" "ssh_rule" {
  network_security_group_id = oci_core_network_security_group.ssh.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "Allow SSH from anywhere"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group" "egress_all" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "egress-all"
}

resource "oci_core_network_security_group_security_rule" "egress_all" {
  network_security_group_id = oci_core_network_security_group.egress_all.id
  direction                 = "EGRESS"
  protocol                  = "all"
  description               = "Allow all Egress traffic"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group" "tailscale" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "tailscale"
}

resource "oci_core_network_security_group_security_rule" "tailscale_rule_udp" {
  network_security_group_id = oci_core_network_security_group.tailscale.id
  direction                 = "INGRESS"
  protocol                  = "17" # UDP
  description               = "Allow Tailscale from anywhere"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  udp_options {
    destination_port_range {
      min = 41641
      max = 41641
    }
  }
}

resource "oci_core_network_security_group_security_rule" "tailscale_rule_all" {
  network_security_group_id = oci_core_network_security_group.tailscale.id
  direction                 = "INGRESS"
  protocol                  = "all"
  description               = "Allow Tailscale from anywhere"
  source_type               = "CIDR_BLOCK"
  source                    = "100.0.0.0/8"
}

resource "oci_core_network_security_group" "vcn_internal" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "vcn-internal"
}

# VCN 내부에서의 모든 트래픽 허용
resource "oci_core_network_security_group_security_rule" "allow_all_vcn_ingress" {
  network_security_group_id = oci_core_network_security_group.vcn_internal.id
  direction                 = "INGRESS"
  protocol                  = "all"
  description               = "Allow all ingress traffic from within VCN"
  source_type               = "CIDR_BLOCK"
  source                    = var.root_locals.env_locals.vpc_cidr_block
}

resource "oci_core_network_security_group" "kubernetes" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "kubernetes-nodeport"
}

# API 서버 통신
# resource "oci_core_network_security_group_security_rule" "kubernetes_api_server" {
#   network_security_group_id = oci_core_network_security_group.kubernetes.id
#   direction                 = "INGRESS"
#   protocol                  = "6" # TCP
#   description               = "Allow Kubernetes API Server"
#   source_type               = "CIDR_BLOCK"
#   source                    = "0.0.0.0/0"  # 실제 환경에서는 더 제한적인 CIDR을 사용하세요
#   tcp_options {
#     destination_port_range {
#       min = 6443
#       max = 6443
#     }
#   }
# }

# NodePort 서비스
resource "oci_core_network_security_group_security_rule" "kubernetes_nodeport" {
  network_security_group_id = oci_core_network_security_group.kubernetes.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "Allow NodePort Services"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0" # 실제 환경에서는 더 제한적인 CIDR을 사용하세요
  tcp_options {
    destination_port_range {
      min = 30010 # 30010
      max = 32767 # max 32767
    }
  }
}

resource "oci_core_network_security_group" "ingress_https" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "ingress-https"
}

resource "oci_core_network_security_group_security_rule" "ingress_https" {
  network_security_group_id = oci_core_network_security_group.ingress_https.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "Allow HTTPS from anywhere"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.2/deploy/static/provider/cloud/deploy.yaml
