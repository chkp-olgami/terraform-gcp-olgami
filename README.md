![GitHub Wachers](https://img.shields.io/github/watchers/CheckPointSW/terraform-azure-cloudguard-network-security)
![GitHub Release](https://img.shields.io/github/v/release/CheckPointSW/terraform-azure-cloudguard-network-security)
![GitHub Commits Since Last Commit](https://img.shields.io/github/commits-since/CheckPointSW/terraform-azure-cloudguard-network-security/latest/master)
![GitHub Last Commit](https://img.shields.io/github/last-commit/CheckPointSW/terraform-azure-cloudguard-network-security/master)
![GitHub Repo Size](https://img.shields.io/github/repo-size/CheckPointSW/terraform-azure-cloudguard-network-security)
![GitHub Downloads](https://img.shields.io/github/downloads/CheckPointSW/terraform-azure-cloudguard-network-security/total)

# Terraform Modules for CloudGuard Network Security (CGNS) - GCP


## Introduction
This repository provides a structured set of Terraform modules for deploying Check Point CloudGuard Network Security in GCP. These modules automate the creation of Virtual Networks, Security Gateways, High-Availability architectures, and more, enabling secure and scalable cloud deployments.

## Repository Structure
`Submodules:` Contains modular, reusable, production-grade Terraform components, each with its own documentation.

`Examples:` Demonstrates how to use the modules.

 
**Submodules:**
* [`packet-intercep`](https://registry.terraform.io/modules/chkp-olgami/olgami/gcp/latest/submodules/packet-intercept) - Deploys GCP Packet Intercept.

Internal Submodules - 

* [`firewall-rule`](https://registry.terraform.io/modules/chkp-olgami/olgami/gcp/latest/submodules/firewall-rule) - Deploys firewall rules on GCP VPCs.
* [`internal-load-balancer`](https://registry.terraform.io/modules/chkp-olgami/olgami/gcp/latest/submodules/internal-load-balancer) - Deploys internal load balanncer.
* [`network-and-subnet`](https://registry.terraform.io/modules/chkp-olgami/olgami/gcp/latest/submodules/network-and-subnet) - Deploys VPC and subnetwork in the VPC.
* [`packet-intercept-common`](https://registry.terraform.io/modules/chkp-olgami/olgami/gcp/latest/submodules/packet-intercept-common) - Deploys Packet Intercept components.


***

# Best Practices for Using CloudGuard Modules

## Step 1: Use the Required Module
Add the required module in your Terraform configuration file (`main.tf`) to deploy resources. For example:

```hcl
provider "google" {
  features {}
}

module "example_module" {
  source  = "CheckPointSW/cloudguard-network-security/gcp//modules/{module_name}"
  version = "{chosen_version}"
  # Add the required inputs
}
```
---

## Step 2: Deploy with Terraform
Use Terraform commands to deploy resources securely.

### Initialize Terraform
Prepare the working directory and download required provider plugins:
```hcl
terraform init
```

### Plan Deployment
Preview the changes Terraform will make:
```hcl
terraform plan
```
### Apply Deployment
Apply the planned changes and deploy the resources:
```hcl
terraform apply
```