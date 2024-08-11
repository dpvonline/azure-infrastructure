variable "CLIENT_ID" {
  type      = string
  sensitive = true
}

variable "CLIENT_SECRET" {
  type      = string
  sensitive = true
}

variable "TENANT_ID" {
  type      = string
  sensitive = true
}

variable "SUBSCRIPTION_ID" {
  type      = string
  sensitive = true
}

variable "REGION" {
  type = string
}

variable "INFRA_NAME" {
  type = string
}

variable "DOMAIN" {
  type = string
}

variable "DEFAULT_EMAIL" {
  type = string
}

variable "DB_ROOT_PW" {
  type = string
}

variable "DB_KEYCLOAK_PW" {
  type = string
}

variable "DB_BIBER_PW" {
  type = string
}

variable "DB_NEXTCLOUD_PW" {
  type = string
}

variable "PGADMIN_PASSWORD" {
  type = string
}

variable "NEXTCLOUD_USER" {
  type = string
}

variable "NEXTCLOUD_PW" {
  type = string
}

variable "COLLABORA_USER" {
  type = string
}

variable "COLLABORA_PW" {
  type = string
}
