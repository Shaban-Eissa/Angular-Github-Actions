# Angular Docker CI/CD Demo
<p align="left">
  <img src="https://github.com/user-attachments/assets/fe90b8b1-be1c-4017-8c99-d28858ab3ad8" alt="Git Hooks Workshop Demo" width="15%" style="max-width: 80px; height: auto;" />
</p>

This repository demonstrates a **complete workflow** for building, containerizing, and deploying an Angular application using Docker and GitHub Actions.

With every push to the `main` branch, the workflow automatically:

1. Builds the Angular app.
2. Creates a Docker image.
3. Pushes the Docker image to Docker Hub.

## Features

- Angular v19 application
- Dockerized app for consistent deployment
- Automated CI/CD with GitHub Actions
- Deployment-ready Docker image

## CI/CD Workflow

The GitHub Actions workflow `.github/workflows/deploy.yml` performs:

- Checkout the code.
- Set up Node.js.
- Install dependencies (`npm ci`).
- Build Angular app into `dist/`.
- Set up Docker Buildx.
- Log in to Docker Hub.
- Build and push Docker image automatically on every push to main.
