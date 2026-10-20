<div align="center">

# 🚀 Kanban Dashboard | Jenkins CI/CD on AWS

### Automated Application Delivery · Containerization · Cloud Deployment

**A hands-on DevOps project demonstrating automated CI/CD, Docker containerization, versioned image delivery, and application deployment on AWS EC2.**

![AWS](https://img.shields.io/badge/AWS-EC2-10212B?style=for-the-badge&logo=amazonwebservices&logoColor=FF9900)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-10212B?style=for-the-badge&logo=jenkins&logoColor=D24939)
![Docker](https://img.shields.io/badge/Docker-Containerization-10212B?style=for-the-badge&logo=docker&logoColor=2496ED)
![React](https://img.shields.io/badge/React-TypeScript-10212B?style=for-the-badge&logo=react&logoColor=61DAFB)

</div>

---

## 🏗️ CI/CD Architecture

```text
GitHub Push
     ↓
GitHub Webhook
     ↓
Jenkins Pipeline
     ↓
Docker Build & Versioned Tag
     ↓
Docker Hub Registry
     ↓
AWS EC2 Deployment
     ↓
Container Health Check
```
## 🧩 Application Overview

| Component | Technology | Purpose |
|---|---|---|
| **Frontend** | React + TypeScript | Interactive Kanban dashboard for task management |
| **Build Tool** | Vite + Node.js | Builds and bundles the frontend application |
| **Web Server** | Nginx | Serves the production frontend |
| **Data Storage** | Browser localStorage | Persists tasks locally without a backend database |
| **Containerization** | Docker | Packages the application for deployment on AWS EC2 |

**Application Flow:** `Browser → Nginx → React Dashboard → localStorage`

## ⚙️ Engineering Highlights

- **Containerization:** Built a multi-stage Docker image using Node.js and Nginx, with a non-root runtime user and container health checks.
- **CI/CD Automation:** Implemented a Jenkins pipeline automating Docker image builds, registry publishing, and AWS EC2 deployment through GitHub webhooks.
- **Image Versioning:** Tagged images using Jenkins build numbers and Git commit SHAs for deployment traceability.
- **Cloud Deployment:** Deployed the React/TypeScript application on AWS EC2 using Docker.
- **Deployment Validation:** Integrated container health checks, Jenkins build logs, and rollback logic for failed deployments.
- **Blue-Green Deployment:** Separately demonstrated health-checked traffic switching using Nginx.

## 📊 Documented Results

| Validation | Outcome |
|---|---|
| Jenkins CI/CD Pipeline | Successful |
| GitHub Webhook Trigger | Verified |
| Docker Image Build & Publishing | Successful |
| AWS EC2 Deployment | Validated |
| Container Health Check | Healthy |
| Blue-Green Deployment Exercise | Demonstrated |

*Results reflect the completed project implementation, not a currently active deployment.*

## 📚 Project Documentation

### 📄 [Explore the Complete Project Documentation →](./Project%20Documentation.pdf)

*Docker · Jenkins CI/CD · AWS EC2 · Security · Health Checks · Deployment Validation*

---

<div align="center">

**GitHub → Jenkins → Docker → AWS EC2**

</div>
