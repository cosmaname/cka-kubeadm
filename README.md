# cka-kubeadm

Creates a K8s cluster on AWS using OpenTofu & kubeadm

## Prerequisites

- OpenTofu 1.8+
- AWS CLI configured with appropriate permissions
- SSH key pair for EC2 instances

## Usage

1. Initialize the project:
   ```bash
   tofu init
   ```

2. Plan the infrastructure:
   ```bash
   tofu plan
   ```

3. Apply the infrastructure:
   ```bash
   tofu apply
   ```

## Verification

To verify OpenTofu compatibility, run:
```bash
./verify_opentofu.sh
```
