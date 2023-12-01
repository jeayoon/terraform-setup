variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS tokyo region"
}

variable "vault_address" {
  type        = string
  default     = "http://127.0.0.1:8200"
  description = "URL address for vault endpoint"
}

variable "tags" {
  type = map(string)
  default = {
    env = "dev_vault"
  }
  description = "dev vault tags"
}
