# Check Point Packet Intercept Terraform module for GCP

This Terraform module deploys Check Point CloudGuard Network Security Packet Intercept solution into a new or existing VPC in GCP.
As part of the deployment the following resources are created:

* [Instance Template](https://www.terraform.io/docs/providers/google/r/compute_instance_template.html)
* [Firewall](https://www.terraform.io/docs/providers/google/r/compute_firewall.html) - conditional creation
* [Instance Group Manager](https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager.html)
* [Autoscaler](https://www.terraform.io/docs/providers/google/r/compute_region_autoscaler.html)
* [Network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)
* [Health Check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_health_check)
* [Backend Service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_region_backend_service)
* [Forwarding Rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule)
* [Intercept Deployment Group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_intercept_deployment_group)
* [Intercept Deployment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_intercept_deployment)
* [Intercept Endpoint Group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_intercept_endpoint_group)
* [Intercept Endpoint Group Association](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_intercept_endpoint_group_association)
* [Security Profile](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_security_profile)
* [Security Profile Group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_security_profile_group)
* [Firewall Policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy)
* [Firewall Policy Rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule)
* [Firewall Policy Association](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_association)


For additional information,
please see the [CloudGuard Network for GCP Packet Intercept Deployment Guide](https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CP_CloudGuard_Network_for_GCP_Autoscaling_MIG/Default.htm)

## Before you begin
1. Create a project in the [Google Cloud Console](https://console.cloud.google.com/) and set up billing on that project.
2. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and read the Terraform getting started guide that follows. This guide will assume basic proficiency with Terraform - it is an introduction to the Google provider.


1. [Create a Service Account](https://cloud.google.com/docs/authentication/getting-started) (or use the existing one). Next, download the JSON key file. Name it something you can remember and store it somewhere secure on your machine. <br/>
2. Give the service account the following permissions (Organization level permission):
   ```
   Custom roles -  
   networksecurity.securityProfiles.* 
   networksecurity.securityProfileGroups.* 
   networksecurity.operations.get 
   ```

## Usage
Follow best practices for using CGNS modules on [the root page](https://registry.terraform.io/modules/CheckPointSW/cloudguard-network-security/azure/latest).
```
provider "google" {
  credentials = "service-accounts/service-account-file-name.json" 
  project     = "project-id"
  region      = "us-central1" 
}

module "pi-test" {
    source  = "chkp-olgami/olgami/gcp//modules/packet-intercept"
    version = "1.0.8"

    # --- Google Provider ---
    service_account_path              = "service-accounts/service-account-file-name.json"
    project                           = "project-id"                    
    organization_id                   = "1111111111111"

    # --- Check Point---
    prefix                            = "chkp-tf-pi"
    license                           = "BYOL"
    image_name                        = "check-point-r8120-gw-byol-mig-631-991001669-v20240923"
    os_version                        = "R8120"
    management_nic                    = "Ephemeral Public IP (eth0)"IP (eth0)"
    management_name                   = "tf-checkpoint-management"
    configuration_template_name       = "tf-checkpoint-template"
    generate_password                 = true
    admin_SSH_key                     = "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxx imported-openssh-key"
    maintenance_mode_password_hash    = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    network_defined_by_routes         = true
    admin_shell                       = "/etc/cli.sh"
    allow_upload_download             = true
    sic_key                           = "xxxxxxxxxxxx"

    # --- Networking ---
    intercept_deployment_zones         = ["us-central1-a"]
    region                            = "us-central1"
    mgmt_network_name                 = ""          
    mgmt_subnetwork_name              = ""      
    mgmt_network_cidr                 = "10.0.4.0/24"
    data_network_name                 = ""  
    data_subnetwork_name              = ""
    data_network_cidr                 = "10.0.5.0/24"
    ICMP_traffic                      = ["123.123.0.0/24", "234.234.0.0/24"]
    TCP_traffic                       = ["0.0.0.0/0"]
    UDP_traffic                       = []
    SCTP_traffic                      = []
    ESP_traffic                       = []
    web_network_name                  = ""
    web_subnetwork_name               = ""
    web_network_cidr                  = "10.0.6.0/24"

    # --- Instance Configuration ---
    machine_type                      = "n1-standard-4"
    cpu_usage                         = 60
    instances_min_group_size          = 2
    instances_max_group_size          = 10
    disk_type                         = "SSD Persistent Disk"
    disk_size                         = 100
    enable_monitoring                 = false
  }
```

## Conditional creation
<br>1. For each network and subnet variable, you can choose whether to create a new network with a new subnet or to use an existing one.

- If you want to create a new network and subnet, please input a subnet CIDR block for the desired new network - In this case, the network name and subnetwork name will not be used:

```
    mgmt_network_name    = "not-use"
    mgmt_subnetwork_name = "not-use"
    mgmt_network_cidr    = "10.0.1.0/24"
```

- Otherwise, if you want to use existing network and subnet, please leave empty double quotes in the CIDR variable for the desired network:

```
    mgmt_network_name    = "network name"
    mgmt_subnetwork_name = "subnetwork name"
    mgmt_network_cidr    = "10.0.1.0/24"
```

<br>2. To create Firewall and allow traffic for ICMP, TCP, UDP, SCTP or/and ESP - enter list of Source IP ranges.
```
ICMP_traffic   = ["123.123.0.0/24", "234.234.0.0/24"]
TCP_traffic    = ["0.0.0.0/0"]
UDP_traffic    = []
SCTP_traffic   = []
ESP_traffic    = []
```
Please leave empty list for a protocol if you want to disable traffic for it.

### Module's variables:
| Name          | Description   | Type          | Allowed values | Default       | Required      |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| service_account_path | User service account path in JSON format - From the service account key page in the Cloud Console choose an existing account or create a new one. Next, download the JSON key file. Name it something you can remember, store it somewhere secure on your machine, and supply the path to the location is stored. (e.g. "service-accounts/service-account-name.json")  | string  | N/A | "" | yes |
| project  | Personal project ID. The project indicates the default GCP project all of your resources will be created in. The project ID must be 6-30 characters long, start with a letter, and can only include lowercase letters, numbers, hyphenst and cannot end with a hyphen. | string  | N/A | "" | yes
| organization_id | Unique identifier for your organization in GCP. It is used to manage resources and permissions within your organization. [For more detailes](https://cloud.google.com/resource-manager/docs/creating-managing-organization)| string  | N/A | "" | yes
| prefix | (Optional) Resources name prefix. <br/> Note: resource name must not contain reserved words based on: [sk40179](https://support.checkpoint.com/results/sk/sk40179).  | string | N/A | "chkp-tf-pi" | no |
| license | Checkpoint license (BYOL or PAYG). | string | BYOL <br/> PAYG <br/> | "BYOL" | no |
| image_name | The autoscaling (MIG) image name (e.g. ccheck-point-r8120-gw-byol-mig-631-991001669-v20240923). You can choose the desired mig image value from [Github](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/gcp/deployment-packages/autoscale-byol/images.py). | string | N/A | N/A | yes |
| os_version |GAIA OS Version | string | R8110;<br/> R8120;<br/> R82; | "R8120" | yes
| management_nic | Management Interface - Autoscaling Security Gateways in GCP can be managed by an ephemeral public IP or using the private IP of the internal interface (eth1). | string | Ephemeral Public IP (eth0) <br/> Private IP (eth1) | "Ephemeral Public IP (eth0)" | no |
| management_name | The name of the Security Management Server as appears in autoprovisioning configuration. (Please enter a valid Security Management name including lowercase letters, digits and hyphens only). | string | N/A | "checkpoint-management" | no |
| configuration_template_name | Specify the provisioning configuration template name (for autoprovisioning). (Please enter a valid autoprovisioing configuration template name including lowercase letters, digits and hyphens only). | string | N/A | "gcp-asg-autoprov-tmplt" | no |
| generate_password  | Automatically generate an administrator password.  | bool | true <br/>false | false | no |
| admin_SSH_key | Public SSH key for the user 'admin' - The SSH public key for SSH authentication to the MIG instances. Leave this field blank to use all project-wide pre-configured SSH keys. | string | A valid public ssh key | "" | no |
| maintenance_mode_password_hash | Maintenance mode password hash, relevant only for R81.20 and higher versions, to generate a password hash use the command 'grub2-mkpasswd-pbkdf2' on Linux and paste it here. | string |  N/A | "" | no |
| network_defined_by_routes | Set eth1 topology to define the networks behind this interface by the routes configured on the gateway. | bool | true <br/>false | true | no |
| admin_shell | Change the admin shell to enable advanced command line configuration. | string | /etc/cli.sh <br/> /bin/bash <br/> /bin/csh <br/> /bin/tcsh | "/etc/cli.sh" | no |
| allow_upload_download | Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point | bool | true/false | true | no |
| region  | GCP region, the gateways will randomly deployed in zones within the provided region  | string  | N/A | "us-central1"  | no |
| intercept_deployment_zones | The zones where the **intercept deployment** will be deployed. Ensure that the web VMs are created in these zones. | list(string)  | N/A | "us-central1-a"  | no |
| mgmt_network_name | The network determines what network traffic the instance can access. | string | N/A | N/A | yes |
| mgmt_subnetwork_name | Assigns the instance an IPv4 address from the subnetwork’s range. Instances in different subnetworks can communicate with each other using their internal IPs as long as they belong to the same network. | string | N/A | N/A | yes |
| mgmt_network_cidr | The range of internal addresses that are owned by this network, only IPv4 is supported (e.g. "10.0.0.0/8" or "192.168.0.0/16"). | string | N/A |"10.0.1.0/24" | no|
| data_network_name | The network determines what network traffic the instance can access. | string | N/A | N/A | yes |
| data_subnetwork_name | Assigns the instance an IPv4 address from the subnetwork’s range. Instances in different subnetworks can communicate with each other using their internal IPs as long as they belong to the same network. | string | N/A | N/A | yes |
| data_network_cidr | The range of internal addresses that are owned by this network, only IPv4 is supported (e.g. "10.0.0.0/8" or "192.168.0.0/16"). | string | N/A |"10.0.2.0/24" | no|
| ICMP_traffic | (Optional) Source IP ranges for ICMP traffic - Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. Please leave empty list to unable ICMP traffic. | list(string) | N/A | [] | no |
| TCP_traffic | (Optional) Source IP ranges for TCP traffic - Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. Please leave empty list to unable TCP traffic. | list(string) | N/A | [] | no |
| UDP_traffic | (Optional) Source IP ranges for UDP traffic - Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. Please leave empty list to unable UDP traffic. | list(string) | N/A | [] | no |
| SCTP_traffic | (Optional) Source IP ranges for SCTP traffic - Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. Please leave empty list to unable SCTP traffic. | list(string) | N/A | [] | no |
| ESP_traffic | (Optional) Source IP ranges for ESP traffic - Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. Please leave empty list to unable ESP traffic. | list(string) | N/A | [] | no |
| web_network_name | The network determines in which network the web VM will be deployed, and where the intercept endpoint group association will be deployed. | string | N/A | N/A | yes |
| web_subnetwork_name | Assigns the instance an IPv4 address from the subnetwork’s range. Instances in different subnetworks can communicate with each other using their internal IPs as long as they belong to the same network. | string | N/A | N/A | yes |
| web_network_cidr | The range of internal addresses that are owned by this network, only IPv4 is supported (e.g. "10.0.0.0/8" or "192.168.0.0/16"). | string | N/A |"10.0.2.0/24" | no|
| machine_type | Machine Type. | string | N/A | "n1-standard-4" | no |
| cpu_usage | Target CPU usage (%) - Autoscaling adds or removes instances in the group to maintain this level of CPU usage on each instance. | number | number between 10 and 90 | 60 | no |
| instances_min_group_size | The minimal number of instances | number | N/A | 2 | no |
| instances_max_group_size | The maximal number of instances | number | N/A | 10 | no |
| disk_type | Storage space is much less expensive for a standard Persistent Disk. An SSD Persistent Disk is better for random IOPS or streaming throughput with low latency. | string | SSD Persistent Disk <br/> Balanced Persistent Disk <br/> Standard Persistent Disk | "SSD Persistent Disk" | no |
| disk_size | Disk size in GB - Persistent disk performance is tied to the size of the persistent disk volume. You are charged for the actual amount of provisioned disk space. | number | number between 100 and 4096 | 100 | no |
| enable_monitoring | Enable Stackdriver monitoring | bool | true <br/> false | false | no |