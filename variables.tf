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

variable "BASE_VM_SIZE" {
  type = string
}

variable "VM_SIZE" {
  type = string
}

variable "VM_SIZE_2" {
  type = string
}

variable "DOMAIN" {
  type = string
}

variable "PROD_DOMAIN" {
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

variable "DB_PGADMIN_USER" {
  type = string
}

variable "DB_PGADMIN_PASSWORD" {
  type = string
}

variable "REDIS_PASSWORD" {
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

variable "DB_CONFLUENCE_NAME" {
  type = string
}

variable "DB_CONFLUENCE_USER" {
  type = string
}

variable "DB_CONFLUENCE_PASSWORD" {
  type = string
}

variable "CONFLUENCE_LICENSE" {
  type = string
}
