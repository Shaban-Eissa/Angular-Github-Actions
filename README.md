# Angular Docker CI/CD Demo

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
