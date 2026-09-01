# Internal Developer Platform

A Backstage-based internal developer platform that unifies GitHub repositories, CI/CD pipelines, Argo CD deployments, and Kubernetes resources into a single developer portal.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Backstage Portal                            │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Catalog    │  │   Docs       │  │   CI/CD      │          │
│  │ (Services)   │  │ (Tech Docs)  │  │ (GitHub)     │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                 │                 │                  │
│         └─────────────────┼─────────────────┘                  │
│                           │                                    │
│                  ┌────────▼────────┐                           │
│                  │  Backstage App  │                           │
│                  │  (Node.js)      │                           │
│                  └────────┬────────┘                           │
│                           │                                    │
│  ┌────────────────────────┼────────────────────────┐          │
│  │                        │                        │          │
│  ▼                        ▼                        ▼          │
│ ┌────────┐          ┌──────────┐           ┌──────────┐       │
│ │GitHub  │          │ Argo CD  │           │Kubernetes│       │
│ │Repos  │          │ Apps     │           │Cluster   │       │
│ └────────┘          └──────────┘           └──────────┘       │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    Plugins                               │  │
│  │  - GitHub (catalog, actions)                             │  │
│  │  - Argo CD (deployment status)                           │  │
│  │  - Kubernetes (resources)                                 │  │
│  │  - TechDocs (documentation)                              │  │
│  │  - CI/CD (pipeline status)                               │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Prerequisites

- Node.js >= 18.x
- Yarn package manager
- GitHub account with personal access token
- k3d Kubernetes cluster
- Argo CD installed
- Docker

## Setup

### 1. Create Backstage App
```bash
npx @backstage/create-app@latest
# Follow the prompts:
# - App name: developer-portal
# - Database: SQLite (for local development)
# - Plugins: GitHub, Argo CD, Kubernetes, TechDocs
```

### 2. Install Dependencies
```bash
cd developer-portal
yarn install
```

### 3. Configure GitHub Integration
```bash
# Add GitHub token to environment
export GITHUB_TOKEN=your_github_token
```

### 4. Configure Backstage
Edit `app-config.yaml`:
```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

### 5. Register Components
Create catalog info files in your repositories:
```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: sample-app
  description: Sample application
  tags:
    - nodejs
    - web
spec:
  type: service
  lifecycle: production
  owner: team-platform
  provides:
    - type: api
      target: ./api-description.md
```

### 6. Start Backstage
```bash
yarn dev
# Access at http://localhost:3000
```

## Features

### Service Catalog
- Auto-discovery of services from GitHub
- Component ownership and lifecycle tracking
- Service dependency mapping
- System architecture visualization

### TechDocs
- Markdown-based documentation
- Auto-generated from repositories
- Versioned documentation
- Searchable content

### CI/CD Integration
- GitHub Actions pipeline status
- Build and deployment history
- Pipeline logs integration
- Trigger deployments from portal

### Argo CD Integration
- Application deployment status
- Sync status and history
- Rollback capabilities
- Health monitoring

### Kubernetes Integration
- Resource visualization
- Pod status and logs
- Service and ingress information
- Resource usage metrics

## Catalog Structure

### Components
- Microservices
- Libraries
- Websites
- APIs

### Systems
- Collections of related components
- System boundaries
- Dependencies

### Resources
- Databases
- Message queues
- Storage buckets
- External services

### APIs
- REST APIs
- GraphQL APIs
- gRPC services

## Example Catalog Entry

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: user-service
  description: User management service
  labels:
    tier: backend
    domain: user-management
  annotations:
    github.com/project-slug: org/user-service
    argocd/app-name: user-service
spec:
  type: service
  lifecycle: production
  owner: team-backend
  dependsOn:
    - resource:database-user
    - resource:cache-redis
  provides:
    - type: api
      target: /docs/api
```

## Developer Experience

### Onboarding
1. New developer accesses Backstage portal
2. Views service catalog and architecture
3. Reads documentation in TechDocs
4. Checks CI/CD pipeline status
5. Monitors deployments via Argo CD
6. Debugs issues with Kubernetes integration

### Service Creation
1. Create GitHub repository
2. Add catalog-info.yaml
3. Backstage auto-discovers service
4. Configure CI/CD pipeline
5. Set up Argo CD deployment
6. Monitor in unified portal

## Verification

```bash
# Check Backstage is running
curl http://localhost:3000

# Check catalog registration
# Visit: http://localhost:3000/catalog

# Check GitHub integration
# Visit: http://localhost:3000/catalog/default/component/sample-app

# Check Argo CD integration
# Visit: http://localhost:3000/argocd

# Check TechDocs
# Visit: http://localhost:3000/docs
```

## Plugins

### GitHub Plugin
- Repository catalog
- Pull request tracking
- Issue management
- Actions integration

### Argo CD Plugin
- Application list
- Sync status
- Deployment history
- Resource tree

### Kubernetes Plugin
- Cluster overview
- Pod management
- Log viewing
- Resource metrics

### TechDocs Plugin
- Documentation rendering
- Search functionality
- Versioning
- Auto-discovery

## Security

- GitHub token authentication
- RBAC for catalog access
- Secure plugin configuration
- Environment variable secrets

## Scaling

For production deployment:
- Use PostgreSQL instead of SQLite
- Deploy to Kubernetes
- Configure authentication (OAuth, SAML)
- Enable caching
- Set up monitoring

## Cleanup

```bash
# Stop Backstage
# Ctrl+C in the terminal

# Remove app
cd ..
rm -rf developer-portal
```
