# https://intersight.com/an/settings/api-keys/
## Generate API key to obtain the API key and secret key
variable "apikey" {
    description = "API key for Intersight account"
    type = string
    default = "59af0e11f11aa10001678016/59af0ceef11aa100016748f0/61f043507564612d33eda2d3"
}

variable "secretkey" {
    description = "Filename (PEM) that provides secret key for Intersight API"
    type = string
    default = "SecretKey.txt"
}

# This is the Intersight URL (could be URL to Intersight Private Virtual Appliance instead)
variable "endpoint" {
    description = "Intersight API endpoint"
    type = string
    default = "https://intersight.com"
}

# This is the target organization defined in Intersight to be configured
variable "organization" {
    type = string
    default = "default"
}

variable "imc_admin_password" {
    type = string
    default = "Cisco123"
}
variable "snmp_password" {
    type = string
    default = "Cisco123"
}