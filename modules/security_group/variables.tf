
variable "main_vpc_id" {
  type = string
  description = "ID of main vpc"
}

variable "shh_port" {
  type = number
  default = 22
  description = "SSH access port"
}

variable "jenkins_port" {
  type = number
  default = 8080
  description = "Jenkins access port"
}

variable "icmp_port" {
  type = number
  default = -1
  description = "ICMP(for ping command) access port"
}

variable "http_port" {
  type = number
  default = 80
  description = "HTTP access port"
}

variable "https_port" {
  type = number
  default = 443
  description = "HTTPS access port"
}

variable "consul_rpc_port" {
  type = number
  default = 8300
  description = "Consul RPC port between services for driving cluster state"
}

variable "consul_lan_gossip_port" {
  type = number
  default = 8301
  description = "Consul port for LAN gossip"
}

variable "consul_http_api_port" {
  type = number
  default = 8500
  description = "Consul HTTP API port"
}

variable "consul_dns_interface_port" {
  type = number
  default = 8600
  description = "Consul DNS interface port"
}

variable "out_port" {
  type = number
  default = 0
  description = "Port for outgoing connections from instances"
}

variable "cidr_blocks" {
  type = list(string)
  default = [
    "0.0.0.0/0"
  ]
  description = "CIDR blocks for internet connection"
}
