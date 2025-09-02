# Angular GitOps Pipeline Demo

<img src="https://github.com/user-attachments/assets/fe90b8b1-be1c-4017-8c99-d28858ab3ad8"  width="15%" style="max-width: 80px; height: auto;" />
<img src="https://github.com/user-attachments/assets/c6512b42-1827-4b93-b419-fc86a524fdb7"  width="25%" style="max-width: 80px; height: auto;"/>
<img src="https://github.com/user-attachments/assets/f4279d32-88ef-4d17-be4f-608dc83219d2"  width="18%" style="max-width: 80px; height: auto;"/>
<br/>
<br/>
This repository demonstrates a complete, automated GitOps workflow for a containerized Angular application. It showcases the "Git as the single source of truth" principle, where every code change automatically updates the application's manifest file, which is then deployed by a Continuous Deployment tool.

## The GitOps Workflow

The entire pipeline is orchestrated by a single commit:

1. **Code Push**: A developer pushes a new code change to the `main` branch.
2. **CI/CD Pipeline**: GitHub Actions is triggered to build a Docker image with a unique SHA tag and push it to Docker Hub.
3. **Manifest Update**: The pipeline automatically updates the `k8s/deployment.yml` file in the repository with the new image tag.
4. **Git as the Source of Truth**: This change is committed and pushed back to the `main` branch.
5. **Automated Deployment**: Argo CD, which continuously monitors the repository, detects the change and automatically pulls the new Docker image and applies the new manifest to the Kubernetes cluster.

## Core Components

- **GitHub Actions**: Our CI/CD engine that automates the build, push, and manifest update process.
- **Docker Hub**: The container registry where the application's Docker images are stored.
- **Kubernetes & Minikube**: A container orchestration system that runs the application, with Minikube serving as a lightweight local cluster.
- **Argo CD**: A declarative, GitOps-based continuous delivery tool that automatically synchronizes the cluster state with the Git repository.

## Features

- Angular v19 application
- Dockerized app for consistent deployment
- Automated CI/CD with GitHub Actions
- GitOps-based continuous deployment with Argo CD
- Kubernetes manifest management
- Automated image tag updates
- Complete end-to-end automation from code to deployment

## Project Structure

```
./src/                              # The Angular application source code
./Dockerfile                        # The multi-stage Dockerfile for building the application
./k8s/                             # Contains the Kubernetes manifest files
  ├── deployment.yml               # Defines the desired state of the application pods
  └── service.yml                  # Exposes the application to be accessible from outside the cluster
./.github/workflows/deploy.yml     # The GitHub Actions workflow file
```

## CI/CD Workflow Details

The `.github/workflows/deploy.yml` workflow is triggered on every push to the `main` branch and performs the following steps:

1. **Checkout repo**: Clones the repository
2. **Set up Node.js & Install dependencies**: Prepares the build environment
3. **Build Angular**: Compiles the Angular application into `dist/`
4. **Build and push Docker image**: Creates a Docker image and tags it with the unique commit SHA (`${{ github.sha }}`)
5. **Update deployment manifest**: Uses `sed` to automatically update the `k8s/deployment.yml` file with the new image tag
6. **Auto-commit manifest changes**: Commits and pushes the updated manifest file back to the repository, which triggers the Argo CD sync

## Deployment

To get this pipeline running, you need a local Minikube cluster with Argo CD installed. Follow these step-by-step instructions:

### Step 1: Setup Minikube

1. **Install Minikube**: Download and install Minikube from the [official website](https://minikube.sigs.k8s.io/docs/start/)

2. **Start Minikube Cluster**: 
```bash
# Start minikube with recommended resources
minikube start

# Verify cluster is running
minikube status
```

3. **Enable Required Add-ons**:
```bash
# Enable ingress addon (optional but recommended)
minikube addons enable ingress

# Enable metrics server (optional)
minikube addons enable metrics-server
```

4. **Verify Kubernetes is Working**:
```bash
# Check nodes
kubectl get nodes

# Check system pods
kubectl get pods
```

### Step 2: Install Argo CD

1. **Create Argo CD Namespace**:
```bash
kubectl create namespace argocd
```

2. **Apply Argo CD Installation Manifest**:
```bash
# Install Argo CD using the official manifest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. **Wait for Argo CD Pods to be Ready**:
```bash
# Check if all pods are running
kubectl get pods -n argocd
```

### Step 3: Access Argo CD

1. **Setup Port Forwarding**:
```bash
# Forward Argo CD server port to localhost
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

2. **Get Initial Admin Password**:
```bash
# Get the initial admin password (for Windows PowerShell):
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | ForEach-Object {
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

3. **Access Argo CD UI**:
   - Open your browser and navigate to: `https://localhost:8080`
   - Username: `admin`
   - Password: Use the password from step 3
   - Accept the self-signed certificate warning

### Step 4: Configure Docker Hub Secret

Create a Docker Hub secret to allow Kubernetes to pull private images:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=docker.io \
  --docker-username=<your-username> \
  --docker-password=<your-password> \
  -n default
```

### Step 5: Deploy Your Application Manifests

1. **Apply Kubernetes Manifests**:
```bash
# Apply your application manifests
kubectl apply -f k8s/

# Check if pods are running
kubectl get pods

# Check services
kubectl get services
```

2. **Verify Application Deployment**:
```bash
# Check deployment status
kubectl get deployments

# Check pod logs if needed
kubectl logs -l app=my-angular-app
```

### Step 6: Configure Argo CD Application

1. **Create Argo CD Application via UI**:
   - Click "NEW APP" in Argo CD UI
   - Fill in the following details:
     - **Application Name**: `my-angular-app`
     - **Project**: `default`
     - **Repository URL**: `https://github.com/Shaban-Eissa/Angular-Github-Actions`
     - **Path**: `k8s`
     - **Cluster URL**: `https://kubernetes.default.svc`
     - **Namespace**: `default`
     - **Sync Policy**: `Automatic`
     - Enable **Auto-Prune** and **Self Heal**

### Step 7: Useful Commands

**Minikube Management**:
```bash
# Stop minikube
minikube stop

# Delete minikube cluster
minikube delete

# Get minikube IP
minikube ip

# SSH into minikube
minikube ssh
```

**Troubleshooting**:
```bash
# Check all resources in default namespace
kubectl get all

# Describe pod for debugging
kubectl describe pod <pod-name>


# Check Argo CD logs
kubectl logs -n argocd deployment/argocd-application-controller
kubectl logs -n argocd deployment/argocd-server
```

## Accessing the Application

Once deployed, you can access your Angular application using the following command:

```bash
minikube service my-angular-app-service --url -n default
```

This command will provide the URL to your application running inside the cluster.

## How It Works

1. **Developer Experience**: Developers only need to push code to the `main` branch
2. **Automatic Building**: GitHub Actions automatically builds and containerizes the application
3. **Image Tagging**: Each build is tagged with the unique commit SHA for traceability
4. **Manifest Updates**: The Kubernetes deployment manifest is automatically updated with the new image tag
5. **GitOps Sync**: Argo CD detects the manifest changes and automatically deploys the new version
6. **Zero Downtime**: Kubernetes handles rolling updates ensuring no service interruption

## Benefits of This Approach

- **Git as Single Source of Truth**: All changes are tracked in Git
- **Automated Pipeline**: No manual intervention required
- **Rollback Capability**: Easy to rollback by reverting Git commits
- **Audit Trail**: Complete history of all deployments
- **Consistency**: Same process for all environments
- **Security**: No need to store cluster credentials in CI/CD pipelines
