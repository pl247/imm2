terraform {

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = "=1.0.34"
        }
    }
}

provider "intersight" {
    apikey = var.apikey
    secretkey = var.secretkey
    endpoint = var.endpoint
}

data "intersight_organization_organization" "my_org" {
    name = var.organization
}

module "intersight_policy_bundle" {
  source = "https://github.com/pl247/tf-policy-bundle-3"

  pod_policy_prefix = "pod"
  pod_id = "1"        
#  1 is for first pod  2 is for second pod,  3 is for third pod    etc. 
#  All Identity Pools for a Pod will contain the POD ID (MAC, WWNN, WWPN, UUID)

  description = "Built by Terraform ${var.pod_policy_prefix}"

  #Every object created in the pod main module will have these tags
  pod_tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" }
  ]



# =============================================================================
# Fabric Interconnect 6454 Ethernet ports
# -----------------------------------------------------------------------------

  #FI ports to be used for ethernet port channel uplink
  port_channel_6454 = [49,50,51,52]

  # FI physical port numbers to be attached to chassis 
  server_ports_6454 = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44]

  # VLAN Prefix ex: vlan   >> name is: vlan-230
  vlan_prefix = "vlan"

  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011"
  switch_vlans_6454 = "100,101,102,313,314,997-999"

# =============================================================================
# Fabric Interconnect 6454 FC Ports and VSANs
# -----------------------------------------------------------------------------
  #6454 FC ports start at Port 1 up to 16 (FC on left of slider)

  # A value of 8 results in 8x 32G FC Port from ports 1 to 8
  # For no FC, set fc_port_count_6454 to 0 and comment out all FC variables or set them to empty sets
  fc_port_count_6454 = 0

  # VSAN ID for FC Port Channel
  fc_uplink_pc_vsan_id_a = 100
  fc_uplink_pc_vsan_id_b = 200

  #  All 6454 FC ports are standard ports so "aggport" must be 0
  fc_port_channel_6454 = [
    # { "aggport" : 0, "port" : 1 },
    # { "aggport" : 0, "port" : 2 },
    # { "aggport" : 0, "port" : 3 },
    # { "aggport" : 0, "port" : 4 },
    # { "aggport" : 0, "port" : 5 },
    # { "aggport" : 0, "port" : 6 },
    # { "aggport" : 0, "port" : 7 },
    # { "aggport" : 0, "port" : 8 }
  ]


# VSAN Trunking is enabled by default. One or more VSANs are required for each FI

  # Fabric A VSAN Set
  fabric_a_vsan_sets = {
    # "vsan100" = {
    #   vsan_number   = 100
    #   fcoe_number   = 1000
    #   switch_id      = "A"
    # }
    # "vsan101"  = {
    #   vsan_number   = 101
    #   fcoe_number   = 1001
    #   switch_id      = "A"
    # }
  }

  # Fabric B VSAN Set
    fabric_b_vsan_sets = {
    # "vsan200" = {
    #   vsan_number   = 200
    #   fcoe_number   = 2000
    #   switch_id      = "B"
    # }
    # "vsan201"  = {
    #   vsan_number   = 201
    #   fcoe_number   = 2001
    #   switch_id      = "B"
    # }
  }
# =============================================================================
# NTP, DNS and SNMP Settings
# -----------------------------------------------------------------------------

  ntp_servers   = ["ca.pool.ntp.org"]
  ntp_timezone  = "America/Chicago"

  dns_preferred = "8.8.8.8"
  dns_alternate = "8.8.4.4"

  snmp_ip       = "127.0.0.1"
  snmp_password = var.snmp_password

# VNIC QoS policy moids Pod-Wide
  vnic_qos_besteffort = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
  vnic_qos_bronze     = module.imm_pod_qos_mod.vnic_qos_bronze_moid
  vnic_qos_silver     = module.imm_pod_qos_mod.vnic_qos_silver_moid
  vnic_qos_gold       = module.imm_pod_qos_mod.vnic_qos_gold_moid
  # vnic_qos_platinum = module.imm_pod_qos_mod.vnic_qos_platinum_moid
  vnic_qos_fc_moid    = module.imm_pod_qos_mod.vnic_qos_fc_moid
}