data "aws_ami" "ubuntu" {
  # AMI owner ID of Canonical
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_eip_association" "master" {
  allocation_id = aws_eip.master.id
  instance_id   = aws_instance.master.id
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = var.master_instance_type
  subnet_id     = module.vpc.public_subnets.0
  key_name      = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_k8s.id,
    aws_security_group.ingress_ssh.id
  ]
  tags = merge(local.tags, { "terraform-kubeadm:node" = "master" })
  # Saved in: /var/lib/cloud/instances/<instance-id>/user-data.txt [1]
  # Logs in:  /var/log/cloud-init-output.log [2]
  # [1] https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts
  # [2] https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts
  user_data = templatefile(
    "${path.module}/user-data.tftpl",
    {
      node              = "master",
      token             = local.token,
      cidr              = var.pod_network_cidr_block,
      master_public_ip  = aws_eip.master.public_ip,
      master_private_ip = null,
      worker_index      = null,
      kube_version      = var.kube_version
    }
  )
}
