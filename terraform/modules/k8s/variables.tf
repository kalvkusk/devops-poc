variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "project_id" {
  type        = string
  default     = "apollo-io-poc"
  description = "project id"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "region"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 3
  description = "number of gke nodes"
}
