resource "azurerm_dns_zone" "web_app" {
  name                = var.DOMAIN
  resource_group_name = azurerm_resource_group.infra.name
}

resource "azurerm_dns_a_record" "web_app_ipv4" {
  name                = "@"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "web_app_ipv6" {
  name                = "@"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}

resource "azurerm_dns_a_record" "db_ipv4" {
  name                = "db"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "db_ipv6" {
  name                = "db"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}

resource "azurerm_dns_a_record" "auth_ipv4" {
  name                = "auth"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "auth_ipv6" {
  name                = "auth"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}

resource "azurerm_dns_a_record" "cloud_ipv4" {
  name                = "cloud"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "cloud_ipv6" {
  name                = "cloud"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}

resource "azurerm_dns_a_record" "office_ipv4" {
  name                = "office"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "office_ipv6" {
  name                = "office"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}

resource "azurerm_dns_a_record" "biber_ipv4" {
  name                = "anmeldung"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "biber_ipv6" {
  name                = "anmeldung"
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}
