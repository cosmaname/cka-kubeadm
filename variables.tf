variable "private_key_file" {
  type        = string
  description = "Filename of the private key of a key pair on your local machine. This key pair will allow to connect to the nodes of the cluster with SSH."
  default     = "~/.ssh/id_ed25519"
}

variable "public_key_file" {
  type        = string
  description = "Filename of the public key of a key pair on your local machine. This key pair will allow to connect to the nodes of the cluster with SSH."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "kubeconfig" {
  type        = string
  description = "Name of the kubeconfig file for the created cluster on the local machine. If this is unset, then the kubeconfig file is saved as '<cluster_name>.conf' in the current working directory."
  default     = null
}

variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make SSH connections to the EC2 instances that form the cluster nodes. By default, SSH connections are allowed from everywhere."
}

variable "allowed_k8s_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make Kubernetes API request to the API server of the cluster. By default, Kubernetes API requests are allowed from everywhere. Note that Kubernetes API requests from Pods and nodes inside the cluster are always allowed, regardless of the value of this variable."
}

variable "control_instance_type" {
  type        = string
  description = "EC2 instance type for the control node (must have at least 2 CPUs and 2 GB RAM)."
  default     = "t3.medium"
}

variable "worker_instance_type" {
  type        = string
  description = "EC2 instance type for the worker nodes."
  default     = "t3.small"
}

variable "num_workers" {
  type        = number
  description = "Number of worker nodes."
  default     = 2
}

variable "vpc_network_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "pod_network_cidr_block" {
  type        = string
  description = "**This is an optional variable, can be set to null**. CIDR block for the Pod network of the cluster. If set, Kubernetes automatically allocates Pod subnet IP address ranges to the nodes (i.e. sets the \".spec.podCIDR\" field of the node objects). If null, the cluster is created without an explicitly determined Pod network IP address range, and the nodes are not allocated any Pod subnet IP address ranges (i.e. the \".spec.podCIDR\" field of the nodes is not set)."
  default     = "172.16.0.0/12"
  # default = null
}

variable "kube_version" {
  type        = string
  description = "K8s release, defaults to smth from 2023"
  default     = "v1.28"
}

variable "calico_version" {
  type        = string
  description = "Calico CNI release, defaults to smth from 2023"
  default     = "v3.26.4"
}
