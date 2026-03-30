output "dashboard_public_ip" {
  description = "Public IP address of the dashboard EC2 instance"
  value       = module.dashboard_ec2_instance.public_ip
}
