terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.40.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.28.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id                       = var.CLIENT_ID
  client_secret                   = var.CLIENT_SECRET
  tenant_id                       = var.TENANT_ID
  subscription_id                 = var.SUBSCRIPTION_ID
  resource_provider_registrations = "all"
}

module "azure" {
  source       = "./azure"
  VM_SIZE      = var.VM_SIZE
  REGION       = var.REGION
  INFRA_NAME   = var.INFRA_NAME
  BASE_VM_SIZE = var.BASE_VM_SIZE
  DOMAIN       = var.DOMAIN
  VM_SIZE_2    = var.VM_SIZE_2
}

locals {
  host                   = module.azure.k8s_konfig.host
  client_certificate     = base64decode(module.azure.k8s_konfig.client_certificate)
  client_key             = base64decode(module.azure.k8s_konfig.client_key)
  cluster_ca_certificate = base64decode(module.azure.k8s_konfig.cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate
}

module "kubernetes" {
  source                 = "./kubernetes"
  INFRA_NAME             = var.INFRA_NAME
  PUBLIC_IP              = module.azure.public_ip
  PUBLIC_IP_V6           = module.azure.public_ip_v6
  DOMAIN                 = var.DOMAIN
  DB_ROOT_PASSWORD       = var.DB_ROOT_PW
  DB_KEYCLOAK_PASSWORD   = var.DB_KEYCLOAK_PW
  DB_BIBER_PASSWORD      = var.DB_BIBER_PASSWORD
  PGADMIN_PASSWORD       = var.PGADMIN_PASSWORD
  DEFAULT_EMAIL          = var.DEFAULT_EMAIL
  DB_NEXTCLOUD_PW        = var.DB_NEXTCLOUD_PW
  COLLABORA_PW           = var.COLLABORA_PW
  COLLABORA_USER         = var.COLLABORA_USER
  NEXTCLOUD_PW           = var.NEXTCLOUD_PW
  NEXTCLOUD_USER         = var.NEXTCLOUD_USER
  DB_BIBER_NAME          = var.DB_BIBER_NAME
  DB_BIBER_USER          = var.DB_BIBER_USER
  DB_NEXTCLOUD_NAME      = var.DB_NEXTCLOUD_NAME
  DB_NEXTCLOUD_USER      = var.DB_NEXTCLOUD_USER
  EMAIL_HOST             = var.EMAIL_HOST
  EMAIL_HOST_PASSWORD    = var.EMAIL_HOST_PASSWORD
  EMAIL_HOST_USER        = var.EMAIL_HOST_USER
  EMAIL_PORT             = var.EMAIL_PORT
  EMAIL_USE_SSL          = var.EMAIL_USE_SSL
  EMAIL_USE_TLS          = var.EMAIL_USE_TLS
  DJANGO_SECRET_KEY      = var.DJANGO_SECRET_KEY
  PROD_DOMAIN            = var.PROD_DOMAIN
  DB_PGADMIN_PASSWORD    = var.DB_PGADMIN_PASSWORD
  DB_PGADMIN_USER        = var.DB_PGADMIN_USER
  REDIS_PASSWORD         = var.REDIS_PASSWORD
  DB_CONFLUENCE_NAME     = var.DB_CONFLUENCE_NAME
  DB_CONFLUENCE_PASSWORD = var.DB_CONFLUENCE_PASSWORD
  DB_CONFLUENCE_USER     = var.DB_CONFLUENCE_USER
  CONFLUENCE_LICENSE     = var.CONFLUENCE_LICENSE
}
