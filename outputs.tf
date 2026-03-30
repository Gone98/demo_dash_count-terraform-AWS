output "dashboard_public_ip" {
  description = "Public IP address of the dashboard instance"
  value       = aws_instance.dashboard_instance.public_ip
}
