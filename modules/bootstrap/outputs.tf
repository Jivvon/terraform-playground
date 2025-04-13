output "instance" {
  value = try(module.instance[0], null)
}
