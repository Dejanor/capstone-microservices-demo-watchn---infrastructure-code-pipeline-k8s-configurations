variable "environment_name" {

}

variable "instance_name" {

}

variable "vpc_id" {

}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  default = {}
}

variable "aurora_engine_version" {
  default = "5.7.mysql_aurora.2.08.1"
}

variable "aurora_source_region" {
  default = ""
}

variable "blocker" {
  default = ""
}

variable "global_cluster_id" {
  default = null
}

variable "db_name" {
  
}

variable "db_password" {
  default = ""
}

variable "instance_type" {
  default = "db.r5.large" # db.t3.medium
}

variable "read_replica_count" {
  default = 0
}

variable "enable_autoscaling" {
  default = false
}