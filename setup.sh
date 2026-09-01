#!/bin/bash

set -e

echo "🚀 Setting up Backstage Internal Developer Platform..."

# Check prerequisites
command -v node >/dev/null 2>&1 || { echo "❌ Node.js is required but not installed. Aborting." >&2; exit 1; }
command -v yarn >/dev/null 2>&1 || { echo "❌ Yarn is required but not installed. Aborting." >&2; exit 1; }

# Check for GITHUB_TOKEN
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  GITHUB_TOKEN environment variable not set"
    echo "Please set it with: export GITHUB_TOKEN=your_token"
    exit 1
fi

# Create Backstage app
echo "📦 Creating Backstage application..."
npx @backstage/create-app@latest developer-portal --skip-install

cd developer-portal

# Install dependencies
echo "📥 Installing dependencies..."
yarn install

# Install additional plugins
echo "🔌 Installing plugins..."
yarn add @backstage/plugin-github @backstage/plugin-argocd @backstage/plugin-kubernetes @backstage/plugin-techdocs

# Copy custom config
echo "⚙️  Configuring Backstage..."
cp ../config/app-config.yaml app-config.yaml

# Copy catalog info
echo "📋 Setting up catalog..."
mkdir -p catalog-info
cp ../catalog-info/all-components.yaml catalog-info/

# Create .env file
echo "🔐 Setting up environment variables..."
cat > .env << EOF
GITHUB_TOKEN=${GITHUB_TOKEN}
ARGOCD_URL=http://localhost:8080
ARGOCD_USERNAME=admin
ARGOCD_PASSWORD=argocd-server
ARGOCD_TOKEN=your_argocd_token
K8S_SERVICE_ACCOUNT_TOKEN=your_k8s_token
EOF

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your actual Argo CD and Kubernetes tokens"
echo "2. Start the development server: yarn dev"
echo "3. Access the portal at http://localhost:3000"
