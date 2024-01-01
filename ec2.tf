data "aws_ami" "ubuntu" {
  # AMI owner ID of Canonical
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_eip_association" "control" {
  allocation_id = aws_eip.control.id
  instance_id   = aws_instance.control.id
}

resource "aws_instance" "control" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = var.control_instance_type
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_k8s.id,
    aws_security_group.ingress_ssh.id
  ]
  tags      = merge(local.tags, { "terraform-kubeadm:node" = "control" })
  # Saved in: /var/lib/cloud/instances/<instance-id>/user-data.txt
  # Logs in:  /var/log/cloud-init-output.log
  # [1] https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts
  user_data = templatefile(
    "${path.module}/user-data.tftpl",
    {
      node              = "control",
      token             = local.token,
      cidr              = var.pod_network_cidr_block,
      control_public_ip  = aws_eip.control.public_ip,
      control_private_ip = null,
      worker_index      = null,
      kube_version      = var.kube_version
    }
  )
}

resource "aws_instance" "workers" {
  count                       = var.num_workers
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = var.worker_instance_type
  subnet_id                   = module.vpc.private_subnets[count.index]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_ssh.id
  ]
  tags      = merge(local.tags, { "terraform-kubeadm:node" = "worker-${count.index}" })
  user_data = templatefile(
    "${path.module}/user-data.tftpl",
    {
      node              = "worker",
      token             = local.token,
      cidr              = null,
      control_public_ip  = null,
      control_private_ip = aws_instance.control.private_ip,
      worker_index      = count.index,
      kube_version      = var.kube_version
    }
  )
}
