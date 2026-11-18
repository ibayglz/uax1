variable "subscription_id" {
  description = "Id de tu suscripción de Azure for Students"
  type        = string
}
variable "location" {
  description = "Región donde se crea todo (una de TUS regiones permitidas)"
  type        = string
}
variable "alias" {
  description = "Tu alias: solo minúsculas y números, por ejemplo pes27"
  type        = string
}
variable "mi_ip" {
 description = "Tu IP pública, para permitir SSH solo desde ella"
 type = string
}
variable "vm_size" {
 description = "Tamaño de la VM (el que te funcionó en el Lab 4)"
 type = string
}
