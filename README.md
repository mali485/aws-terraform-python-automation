# ☁️ Automated AWS Infrastructure Deployment via Terraform & Python

## 📌 Project Overview
Deploying scalable cloud infrastructure manually via the AWS Console is prone to human error and difficult to track. This project establishes an automated, "Infrastructure-as-Code" (IaC) pipeline. It utilizes **Terraform** to provision a secure, scalable AWS EC2 instance dynamically, while a custom **Python orchestration script** acts as a wrapper to seamlessly execute all Terraform commands (`init`, `plan`, `apply`) with one click, providing real-time terminal feedback.

## ✨ Key Features & Architecture
* **IaC Provisioning:** End-to-end AWS resource creation (VPC, Subnets, Security Groups, EC2) using HashiCorp Terraform.
* **Dynamic AMI Fetching:** Eliminated static, hardcoded AMI IDs. The script dynamically queries AWS for the latest official Ubuntu 22.04 LTS image.
* **Network & Security Automation:** Automatically locates valid Subnets within the Default VPC and provisions custom Security Groups (ports 22, 80, 443).
* **Python Orchestration:** Utilized the `python_terraform` library to wrap execution phases, establishing a streamlined, one-click CI/CD-style deployment loop.

## 🧠 Technical Challenges & Solutions

| The Challenge | Root Cause | Engineering Solution |
| :--- | :--- | :--- |
| **AMI ID Deprecation** | EC2 creation failed because standard AMI IDs are region-specific and periodically deprecated by AWS. | Implemented a `data "aws_ami"` block to continuously query and filter the AWS marketplace for the `most_recent` Canonical Ubuntu 22.04 image. |
| **Subnet Allocation Failures** | The instance failed to automatically route and bind to a valid network path within the VPC. | Integrated a `data "aws_subnets"` block, ensuring Terraform programmatically binds the instance to the first available valid subnet (`ids[0]`). |
| **Resource Race Conditions** | EC2 attempted to initialize before required security and networking rules were fully provisioned. | Forced strict execution ordering by applying the `depends_on` meta-argument, linking the EC2 build directly to the completion of Key Pairs and Security Groups. |

## 🚀 Execution & Automation Script

To execute this entire infrastructure build without interacting directly with the Terraform CLI:

```python
# The python orchestrator runs:
# 1. tf.init()
# 2. tf.plan()
# 3. tf.apply(skip_plan=True) # Auto-Approve deployment
python3 deploy.py

✅ Successful Deployment Output
Here is the final execution output from the Python wrapper script, confirming successful Terraform planning, resource provisioning, and AWS deployment.

Built with 💻 by Muhammad Ali | Cloud Computing & DevOps Enthusiast
