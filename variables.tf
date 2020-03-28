
variable "name" {}
variable "ports" {}
variable "min_size" {
    default = 1
}
variable "max_size" {
    default = 1
}
variable "desired_capacity" {
    default = 1
}
variable "instance_type" {
    default = "t2.micro"
}
