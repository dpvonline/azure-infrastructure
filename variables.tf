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

variable "DJANGO_SECRET_KEY" {
  type = string
}

variable "DB_KEYCLOAK_PW" {
  type = string
}

variable "DB_BIBER_NAME" {
  type = string
}

variable "DB_BIBER_USER" {
  type = string
}

variable "DB_BIBER_PASSWORD" {
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

variable "DB_NEXTCLOUD_NAME" {
  type = string
}

variable "DB_NEXTCLOUD_USER" {
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

variable "EMAIL_HOST" {
  type = string
}

variable "EMAIL_HOST_USER" {
  type = string
}

variable "EMAIL_HOST_PASSWORD" {
  type = string
}

variable "EMAIL_PORT" {
  type = string
}

variable "EMAIL_USE_TLS" {
  type = bool
}

variable "EMAIL_USE_SSL" {
  type = bool
}
