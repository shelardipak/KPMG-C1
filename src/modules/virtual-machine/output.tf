output "id" {
  description = "The id of VM created"
  value       = "${azurerm_windows_virtual_machine.winapp.id}"
}