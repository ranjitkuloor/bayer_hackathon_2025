variable "region" {}
variable "cluster_name" {}
variable "project_name" {}
variable "availability_zones" {
  type = list(string)
}
variable "node_desired_size" {
  type = number
}
variable "node_max_size" {
  type = number
}
variable "node_min_size" {
  type = number
}
variable "node_instance_type" {
  type = string
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}