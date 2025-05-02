locals {
  users = toset(split(",", var.users))
}

resource "azuread_user" "users" {
  for_each = local.users

  user_principal_name = "${each.key}@${var.tenant_domain}"
  display_name        = each.key
  password            = "Password123!"
}

resource "azurerm_resource_group" "rgs" {
  for_each = local.users

  name     = "rg-aztflab-${each.key}"
  location = var.location
}

resource "azurerm_role_assignment" "rg_contributors" {
  for_each = local.users

  scope                = azurerm_resource_group.rgs[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_user.users[each.key].object_id
}
