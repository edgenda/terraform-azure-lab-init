resource "azurerm_resource_group" "rgs_state" {
  for_each = var.use_state ? local.users : []

  name     = "rg-aztflab-${each.key}-state"
  location = var.location
}

resource "azurerm_storage_account" "states" {
  for_each = azurerm_resource_group.rgs_state

  name                     = substr("staztflab${each.key}state", 0, 24)
  resource_group_name      = each.value.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

moved {
  from = azurerm_storage_account.state
  to = azurerm_storage_account.states
}

resource "azurerm_storage_container" "tfstate" {
  for_each = azurerm_storage_account.states

  name                  = "tfstate"
  storage_account_id    = each.value.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "rgs_state_readers" {
  for_each = azurerm_resource_group.rgs_state

  scope                = each.value.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.users[each.key].object_id
}

resource "azurerm_role_assignment" "tfstate_storage_key_operator" {
  for_each = azurerm_storage_account.states

  scope                = each.value.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_user.users[each.key].object_id
}

resource "azurerm_role_assignment" "tfstate_blob_contributors" {
  for_each = azurerm_storage_account.states

  scope                = each.value.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_user.users[each.key].object_id
}
