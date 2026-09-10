# Welcome to the Three-Tier Application project.

**Problem:**

A business in Africa needed to move its application online and provide customers with a responsive and reliable login and signup experience.

**Solution:**

The project uses a three-tier architecture consisting of a **frontend, backend, and database**, deployed using cloud infrastructure.

This README documents the **application development and infrastructure setup process**, allowing you to follow the steps and reproduce the project.

## Table of Contents

* [App Development](#app-development)

  * [Backend Application](#backend-application)

    * [Dependencies](#dependencies)
  * [Frontend Application](#frontend-application)
* [Infrastructure](#infrastructure)

  * [Requirements](#requirements)
  * [Infrastructure Modules](#infrastructure-modules)

    * [Compute](#compute)

      * [Application Load Balancer (`alb.tf`)](#application-load-balancer-albtf)
      * [Frontend Launch Template (`launch-template.tf`)](#frontend-launch-template-launch-templatetf)
      * [Auto Scaling Group (`asg.tf`)](#auto-scaling-group-asgtf)
      * [Backend EC2](#backend-ec2)
    * [Network](#network)

      * [VPC Network](#vpc-network)
      * [Frontend Public Routing](#frontend-public-routing)
      * [Backend Private Routing](#backend-private-routing)
      * [Database Subnets](#database-subnets)
    * [Security](#security)

      * [ALB Security Group](#alb-security-group)
      * [Frontend Security Group](#frontend-security-group)
      * [Backend Security Group](#backend-security-group)
      * [Database Security Group](#database-security-group)
    * [Database](#database)
    * [Storage](#storage)
    * [IAM](#iam)

      * [Frontend EC2](#frontend-ec2)
      * [Backend EC2](#backend-ec2-1)
      * [GitHub Actions](#github-actions)
    * [`main.tf` & `provider.tf`](#maintf--providertf)
* [Deployment](#deployment)

  * [1. Provision the Infrastructure](#1-provision-the-infrastructure)
  * [2. Configure GitHub Actions](#2-configure-github-actions)
  * [3. Trigger the Deployment](#3-trigger-the-deployment)
  * [4. Access the Application](#4-access-the-application)
  * [5. For troubleshooting or administration](#5-for-troubleshooting-or-administration)

    * [Updating the Application](#updating-the-application)

## App Development

The application was kept simple to support the project's primary focus: deploying a three-tier application using cloud infrastructure.

### Backend Application

The backend was built using Node.js and TypeScript with Express.

The application provides authentication endpoints for:

* User signup
* User login

The backend is organized into:

* Routes
* Controllers
* Database connection

#### Dependencies

The backend dependencies are defined in `package.json`.

To install the project dependencies, run:

```bash
npm install
```

### Frontend Application

The frontend was built using:

* **HTML** — page structure and rendering
* **CSS** — styling
* **JavaScript** — application logic and communication with the backend

The frontend communicates with the backend using HTTP requests to the authentication endpoints.

## Infrastructure

The infrastructure is the core of the solution, designed around the application's needs to deploy and run it in the cloud.

### Requirements

* Users should be able to access the frontend from the internet.
* The frontend should communicate with the backend.
* The backend should communicate with the database.
* The backend and database should not be directly accessible from the internet.
* The frontend should be highly available.
* The application should provide a responsive experience for users.
* The infrastructure should be reproducible using Terraform.

### Infrastructure Modules

Terraform supports modular infrastructure, allowing resources to be separated by responsibility and reused where needed.

### Compute

#### Application Load Balancer (`alb.tf`)

With multiple frontend EC2 servers, we needed a single point of entry for users. We therefore deployed an Application Load Balancer in the public subnets to receive traffic from the internet and distribute it across the frontend servers.

The ALB uses a **target group** to define and track the frontend instances that can receive traffic, while a **listener** receives incoming requests and forwards them to the target group.

#### Frontend Launch Template (`launch-template.tf`)

Because the frontend servers use the same configuration, we created a launch template containing their common configuration. This allows new frontend instances to be created consistently.

#### Auto Scaling Group (`asg.tf`)

We used an Auto Scaling Group to manage the frontend instances across two Availability Zones, providing the required frontend availability and allowing instances to be replaced when needed.

#### Backend EC2

The backend was deployed on a single EC2 instance because the application only required a simple backend server for this project.

### Network

#### VPC Network

We created a VPC with the CIDR block `10.0.0.0/16` to provide the network for the application.

#### Frontend Public Routing

The frontend needed to be accessible from the internet, so we created two public subnets in different Availability Zones.

We attached an **Internet Gateway** to the VPC to provide internet connectivity.

We then created a route table with a default route to the Internet Gateway:

```text
0.0.0.0/0 → Internet Gateway
```

The route table was associated with both frontend public subnets, making them public subnets.

#### Backend Private Routing

The backend needed to remain private, so we created one private subnet in a single Availability Zone.

Because the backend still needed outbound internet access, we created a **NAT Gateway** in a public subnet. The NAT Gateway uses an **Elastic IP** to provide a stable public IP for outbound traffic.

We then created a private route table with a default route to the NAT Gateway:

```text
0.0.0.0/0 → NAT Gateway
```

The route table was associated with the backend private subnet.

This allows the backend to initiate outbound connections without being directly reachable from the internet.

#### Database Subnets

The database also needed to remain private. We therefore created two private subnets in different Availability Zones.

These subnets were used to create an **RDS DB subnet group**, allowing the database to be deployed within the VPC across the required Availability Zones.

### Security

We created four security groups to control traffic between the components of the application.

#### ALB Security Group

To make the application accessible from the internet, the ALB allows inbound HTTP traffic from the internet and allows outbound traffic.

#### Frontend Security Group

The frontend EC2 instances allow inbound HTTP traffic only from the ALB, ensuring users reach the frontend through the load balancer.

SSH access was also allowed from **EC2 Instance Connect** for administration.

#### Backend Security Group

The backend allows inbound traffic on port `8080` only from the frontend security group.

This keeps the backend inaccessible directly from the internet while allowing the frontend to communicate with it.

#### Database Security Group

The database allows inbound PostgreSQL traffic on port `5432` only from the backend security group.

This ensures that only the backend can communicate with the database.

### Database

We used **Amazon RDS PostgreSQL** to provide the application's database.

The database was configured as a private RDS instance using the DB subnet group and security group created earlier. The database credentials are managed through **AWS Secrets Manager** rather than being stored directly in the application configuration.

### Storage

We created a private **S3 bucket** to store the application artifacts for both the frontend and backend.

The EC2 instances retrieve these artifacts during startup using their **user data** scripts, allowing the application servers to be provisioned with the required application files automatically.

### IAM

We created IAM identities and permissions for the services that needed access to AWS resources.

#### Frontend EC2

The frontend servers needed to retrieve the frontend application files from S3. We therefore created an IAM role with permission to read the S3 bucket and an instance profile that allows the EC2 instances to use the role.

#### Backend EC2

The backend needed to retrieve its application files from S3 and access the database credentials stored in Secrets Manager. We therefore created an IAM role with permissions for these resources and attached it to the backend EC2 through an instance profile.

The backend role also uses **AmazonSSMManagedInstanceCore** to allow administration through AWS Systems Manager Session Manager.

#### GitHub Actions

We needed GitHub Actions to automatically upload the frontend and backend application files to S3 whenever changes were pushed. The workflow therefore needed AWS credentials with permission to upload the files to the S3 bucket, which we provided through an IAM user.

The workflow is defined in `.github/workflows/deploy.yaml`.

#### `main.tf` & `provider.tf`

The `main.tf` file is used to configure and build the infrastructure modules that make up the project.

The `provider.tf` file configures Terraform and specifies the AWS provider and region used to provision the infrastructure.

## Deployment

### 1. Provision the Infrastructure

From the `Infrastructure` directory, initialize Terraform and provision the infrastructure: (also ensure you are connected to the AWS CLI)

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Wait for Terraform to complete successfully.

> **Tip:** The EC2 `user_data` scripts are configured to wait for the application artifacts to become available in S3. The servers will continue polling until the required frontend and backend files have been uploaded.

### 2. Configure GitHub Actions

Create the required GitHub repository secrets using the AWS credentials for the IAM user created for GitHub Actions.

The secret names must match the names referenced in `.github/workflows/deploy.yaml`.

### 3. Trigger the Deployment

Push the application code to the GitHub repository:

```bash
git add .
git commit -m "Deploy application"
git push
```

Open the **Actions** tab in GitHub and verify that the deployment workflow completes successfully.

The workflow uploads the frontend and backend application files to their respective locations in the S3 artifact bucket.

### 4. Access the Application

After the workflow succeeds, retrieve the **DNS name of the Application Load Balancer**.

Open the address in a browser using **HTTP**, not HTTPS:

```text
http://<alb-dns-name>
```

The frontend application should load.

Test the application by:

* Creating a new account using **Sign Up**
* Logging in using **Login**
* Confirming that the requests successfully reach the backend and database

### 5. For troubleshooting or administration:

* **Frontend EC2:** Use **EC2 Instance Connect**. The frontend security group allows SSH access through the configured EC2 Instance Connect prefix list.
* **Backend EC2:** Use **AWS Systems Manager Session Manager**. The backend IAM role includes the permissions required for SSM access.

#### Updating the Application

The deployment setup is intentionally simple: the EC2 instances retrieve the application files only when they start.

If frontend or backend application files are changed and pushed to GitHub, the workflow will update the files in S3, but the existing EC2 instances will not automatically reload the new files.

For frontend changes:

1. Push the changes to GitHub and wait for the workflow to complete.
2. Terminate the existing frontend EC2 instances.
3. The Auto Scaling Group will automatically launch replacement instances.
4. The new instances will retrieve the updated files from S3 during startup.

For backend changes:

1. Push the changes to GitHub and wait for the workflow to complete.
2. Terminate the existing backend EC2 instance.
3. Run:

```bash
terraform apply
```

4. Terraform will provision a replacement backend instance.
5. The new instance will retrieve the updated backend files from S3 during startup.

### 6. Destroy the Infrastructure

To avoid unnecessary AWS costs after completing the project, destroy the infrastructure when it is no longer needed:

```bash
terraform destroy
```

> **Important:** The GitHub Actions IAM user will not be destroyed because its credentials are stored in GitHub and are still required by the deployment workflow.


thumbs up for today!👍