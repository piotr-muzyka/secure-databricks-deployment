# secure-databricks-deployment

The following repository contains Azure Databricks design document implementing enterprise-grade security solutions.

# Table of Contents

- [Design Considerations](#design-considerations)
  - [Networking](#networking)
  - [Data Encryption](#data-encryption)
  - [Access](#access)
  - [Secrets](#secrets)
  - [Data Governance](#data-governance)
- [Deployment](#deployment)
- [Logging](#logging)
- [Threat Detection](#threat-detection)
- [Limitations](#limitations)

# Design Considerations

Diagram 1 - Databricks architecture
![Alt Text](assets/architecture-diagram.png "Architecutre diagram")

## Networking

Deploy your Azure Databricks workspace in private subnets without any inbound access to your network. Clusters will utilize a secure connectivity mechanism to communicate with the Azure Databricks infrastructure, without requiring public IP addresses for the nodes

- Deployment in own virtual network (bring your own network)
- Implement Azure Private Link – Ensures all traffic remains within Microsoft’s secure network backbone.
- Implementing network isolation is crucial to prevent unauthorized access.

- Restrict virtual machine access – Prevent SSH access and use only approved images scanned for vulnerabilities.

- Use Dynamic IP access lists – Allow admin access to workspaces exclusively from corporate networks.

- Leverage VNet injection – Securely connect to other Azure services, on-premises data, and network appliances.

- Adopt Secure Cluster Connectivity and hub/spoke architecture – Prevents exposing cluster nodes to the internet and restricts public IP assignments.


- Implement Azure Private Link – Encrypts traffic between users, notebooks, and compute clusters, keeping it off the public internet.

- Restrict virtual machine access – Prevent unauthorized installations and enforce security baselines for cluster images.
- Use VNet injection – Allows secure connections to Azure services, on-premises networks, and network appliances for enhanced monitoring.
- Azure private link to encrypt all traffic between users and Azure Databricks notebooks and compute

Network Isolation: Deploy Databricks in a customer-managed VNet with Private Link.


https://community.databricks.com/t5/administration-architecture/vnet-injection-container-and-container-subnet/td-p/81887
Public Subnet (host): The public subnet is typically used for resources that need to communicate with the internet or other Azure services. In Azure Databricks, this subnet is used for driver nodes of the clusters that require outbound internet access for various reasons, such as downloading Maven packages.

Private Subnet (container): The private subnet, on the other hand, is used for resources that do not need direct internet access. In Azure Databricks, this subnet is used for worker nodes of the clusters. They communicate with the driver nodes and other Azure services like Azure Blob storage or Azure Data Lake Storage, without needing a direct internet connection.

Azure Databricks requires two IP for each cluster node: one IP address for the host in the host subnet and one IP address for the container in the container subnet.


## Data encryption
Bring Your Own Key shall be implemented with customer managed keys used for encryption at rest of following components:
- Notebooks and workspace metadata
- DBFS root storage
- managed disks

Encryption keys will be rotated periodically to mitigate risks associated with key compromise.

 While this makes the solution more complex use of customer managed keys provides an additional layer of security to the platform ensuring data can be only accessed with the Key that is under organisation control (in contrary to platform managed keys which are controlled by vendor).

## Access
- Use Microsoft Entra ID credential passthrough – Eliminates the need for service principals when accessing Azure Data Lake Storage.
- Ensure managed user access – Microsoft Entra ID enables single sign-on and Conditional Access policies for enhanced security.
- use Azure Active Directory (AAD) tokens to utilize the non-UI capabilities of your Azure Databricks workspace

- Isolate workspaces, compute, and data from public access – Restrict access to authorized personnel only.
- Least Privilege Access: Use Unity Catalog for fine-grained access control to data assets.
Unity catalog:
- helps with the user management, done on the account level
- in contrary to hive metastore, unity catalog has following benefits: 
    - Data catalog
    - centralized governance across workspaces
    - mult-cloud support
    - automatic data lineage support
    - enhanced security with fine-grained access 

Unity Catalog policies to demonstrate how fine-grained permissions can be implemented effectively.

## Secrets

Secrets management: via Azure Key Vault.
Environment-specific configurations stored in Delta Lake. (@TODO Provide additional details on how Delta Lake will store environment-specific configurations securely (e.g., encryption or access control).)

## Data Governance
Consider elaborating on how data governance policies will be enforced (e.g., data classification, retention policies, audit trails).

## Deployment
Deployment of the solution is based on Terraform Infrastructure as code and Azure natvice CI/CD - Azure DevOps deployment pipeline.

Diagram 2 - Deployment topology
![Alt Text](assets/deployment-topology.png "Deployment Topology")

Key considerations:
- Terraform with Databricks asset bundles for workspace/cluster provisioning.
- Terraform code should be versioned using VCS like GitHub, Bitbucket or Gitlab.
- Terraform backend state file should be managed remotely, using Azure blob storage (for local use it can be configured with a backend.tf file as in example)
- Azure DevOps deployment pipeline shall use a custom deployment Service Principal which is assigned  permissions required to deploy Azure services to Azure subscription, following least privilege principle,
- Azure DevOps pipeline shall be a multi-stage one, containing a manual verification step before the deployment to production environments to ensure applied changes are not going to affect system availability and are compliant (review process in place),
- Resources deployed with Terraform should have tags clearly reflecting ownership and environment level,

Exemplary ADO pipeline code enclosed in the repository.
Exemplary Terraform code included in the repository. 
Tested with terraform 1.5.7, azurerm v3.117.1
## Logging
Azure Databricks Diagnostic Logs capture privileged activities, file access, workspace modifications, cluster resizing, and file-sharing activities for security auditing. Logs enable monitoring of workspace access and user actions to ensure transparency in platform activity.

Azure Databricks platform activity covering who’s, what, when actions shall be implemented by enablingAzure Databricks Diagnostic Logs.

This solution allows to:
– Captures privileged activities, file access, and workspace modifications for security auditing
– Monitor and audit workspace access, cluster resizing, and file-sharing activities.


## Threat detection
Azure Databricks logs shall be monitored for file integrity, any unusual user activity and changes around permissions. Threat detection involves monitoring Azure Databricks logs for unusual user activity, file integrity issues, and permission changes. Audit logs are streamed to Azure Sentinel for SIEM integration, and egress traffic is inspected using Azure Firewall or Network Virtual Appliances.



Exemplary use cases to monitor:
- Unusual user activity:
  - failed login attempts
  - impossible travel (switches between geo locations in short time)
  - abnormal API call frequencies
- File Integrity Monitoring
  - unauthorised file modifications
- permission and configuration changes
  - privilege escalation attempt 

Additional considerations:
-  SIEM Integration: Stream audit logs to Azure Sentinel.
- Use Azure Firewall/NVA to inspect egress traffic.

## Limitations:
-  It is not possible to replace an existing VNet in a workspace with another one, if it was necessary a new workspace, a new VNET must be created.
- It is also not possible to add SCC to the workspace once it has already been created, if it was necessary, the workspace must also be recreated
- Potential challenges in managing multiple workspaces under Unity Catalog governance.

## To cover
Security and Compliance Challenges – Ensuring data security and compliance with regulations like GDPR and HIPAA is critical. Azure Databricks offers built-in encryption, identity management, and secure access controls to help organizations meet compliance requirements.

- Audit - Azure storage explorer, data on who is processing data and when
- RBAC with ADLS Gen 2

https://www.databricks.com/blog/2020/05/04/azure-databricks-security-best-practices.html
