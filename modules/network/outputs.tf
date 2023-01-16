output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "The ID of the public subnet."
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "The ID of the private subnet."
}
