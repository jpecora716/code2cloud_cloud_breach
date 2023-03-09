#Required: AWS Profile

#Required: AWS Region
variable "region" {
  default = "us-east-1"
}
#Required: code2cloudID Variable for unique naming
variable "code2cloudid" {

}
#Required: User's Public IP Address(es)
variable "code2cloud_whitelist" {
  default = "0.0.0.0/0"
}
#SSH Public Key
variable "ssh-public-key-for-ec2" {
  default = "panw.pub"
}
#SSH Private Key
variable "ssh-private-key-for-ec2" {
  default = "panw"
}
#Stack Name
variable "stack-name" {
  default = "code2cloud"
}
#Scenario Name
variable "scenario-name" {
  default = "code2cloud-scenario"
}

variable "backend" {
    default = "code2cloud"
}