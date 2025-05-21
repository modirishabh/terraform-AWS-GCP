output "tr_ec2_public_ip" {
  value = aws_instance.tr_ec2.public_ip
}

output "tr_ec2_network_interface_id" {
  value = aws_instance.tr_ec2.primary_network_interface_id
}

output "nw_ec2_public_ip" {
  value = aws_instance.nw_ec2.public_ip
}

output "nw_ec2_network_interface_id" {
  value = aws_instance.nw_ec2.primary_network_interface_id
}
