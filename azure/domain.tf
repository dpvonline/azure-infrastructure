resource "azurerm_dns_zone" "web_app" {
  name                = var.DOMAIN
  resource_group_name = azurerm_resource_group.infra.name
}

locals {
  # Add or remove subdomain labels here; "@" represents the zone apex
  dns_record_names = [
    "@",
    "db",
    "cloud",
    "office",
    "anmeldung",
    # "auth", # uncomment to enable
  ]
}

resource "azurerm_dns_a_record" "records_ipv4" {
  for_each            = toset(local.dns_record_names)
  name                = each.key
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_dns_aaaa_record" "records_ipv6" {
  for_each            = toset(local.dns_record_names)
  name                = each.key
  zone_name           = azurerm_dns_zone.web_app.name
  resource_group_name = azurerm_resource_group.infra.name
  ttl                 = 60
  target_resource_id  = azurerm_public_ip.nginx_ip_v6.id
}
