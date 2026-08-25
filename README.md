# Kanban Task Manager — Dockerized CI/CD Deployment on AWS with Jenkins

A Kanban-style task manager (React + TypeScript + Vite) deployed as a Docker container on AWS EC2, with a Jenkins-based CI/CD pipeline triggered by GitHub pushes.

**Live app:** http://15.252.139.5/
**Docker Hub:** [priyanp/project-kanban-dashboard](https://hub.docker.com/repository/docker/priyanp/project-kanban-dashboard/general)
**GitHub:** [Kanban Dashboard](https://github.com/priya-dharshini-sankar/Kanban-Dashboard-Project)

---

## How It Works

```text
GitHub → Jenkins → Docker Build → Docker Hub → AWS EC2 → Health Check → Live
```

Every push to `main` triggers Jenkins automatically through a GitHub webhook. Jenkins builds a fresh Docker image, pushes it to Docker Hub, deploys it to the EC2 instance, and health-checks it before calling the deployment successful.

---

## Tech Stack

React, TypeScript, and Vite on the frontend; Docker (multi-stage build, Nginx runtime) for containerization; Jenkins for CI/CD; AWS EC2 for hosting; Docker Hub as the image registry.

---

## Docker Setup

The image is built in two stages — a Node build stage that compiles the app, and a slim Nginx stage that serves only the compiled output. This keeps the final image small and free of source code or dev dependencies. It includes a HEALTHCHECK so Docker can monitor container health automatically.

The container runs as a non-root user rather than root, and a `.dockerignore` file keeps things like `node_modules`, `.git`, and `.env` out of the build entirely. No secrets or credentials are stored in the Dockerfile or baked into the image.

---

## Registry & Versioning

Images are pushed to Docker Hub tagged with the Jenkins build number and Git commit SHA (e.g. `build-4-e89ead4`) rather than relying on `latest`, so every deployed version is traceable back to the exact commit that produced it.

---

## AWS Infrastructure

The app runs on a `t3.small` Ubuntu EC2 instance that also hosts Jenkins. Nginx listens on port 80 and routes traffic to the active Docker container.

---

## Jenkins Configuration

Jenkins connects to this GitHub repo using credentials stored securely in its own credentials store (GitHub, Docker Hub, and AWS) — nothing is ever hardcoded. The pipeline job reads its stages directly from the Jenkinsfile committed to the repo.

---

## The Pipeline

The Jenkinsfile runs six stages on every build: checkout the latest code, build and tag the Docker image, push it to Docker Hub, deploy it to EC2, run a health check, and roll back automatically if anything fails along the way.

A GitHub webhook means this whole sequence kicks off the moment code is pushed to `main` — nobody has to trigger a build by hand.

---

## Monitoring & Logs

Jenkins keeps a full build history, so both successful and failed runs (and exactly what went wrong) stay visible for troubleshooting. On the EC2 side, standard Docker commands confirm the container is running, healthy, and serving real traffic.

---

## Resource Limits

The container is capped at 512 MB memory and 1 CPU, sized to leave enough headroom for Jenkins to run comfortably alongside it on the same instance.

---

## Zero-Downtime Deployment

Deployments use a blue-green approach: the new container starts up alongside the old one on a separate port and is health-checked independently. Traffic is only switched over to it once it's confirmed healthy, and the old container is removed afterward. The app stays reachable the entire time.
