#!/bin/bash
# Quick deployment script for Fly.io

set -e

echo "🚀 Journal App - Fly.io Deployment"
echo "=================================="

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    echo "❌ Fly CLI not found. Installing..."
    echo "Please run: brew install flyctl"
    echo "Or visit: https://fly.io/docs/hands-on/install-flyctl/"
    exit 1
fi

# Check if logged in
if ! flyctl auth whoami &> /dev/null; then
    echo "🔐 Please login to Fly.io first:"
    flyctl auth login
fi

# Check if app exists
if [ ! -f "fly.toml" ]; then
    echo "📝 No fly.toml found. Launching new app..."
    flyctl launch --no-deploy
    
    echo ""
    echo "⚙️  Setting secrets..."
    SECRET_KEY_BASE=$(mix phx.gen.secret)
    TOKEN_SIGNING_SECRET=$(mix phx.gen.secret)
    
    flyctl secrets set SECRET_KEY_BASE="$SECRET_KEY_BASE"
    flyctl secrets set TOKEN_SIGNING_SECRET="$TOKEN_SIGNING_SECRET"
    flyctl secrets set DATABASE_PATH="/data/journal.db"
fi

echo ""
echo "🚢 Deploying to Fly.io..."
flyctl deploy

echo ""
echo "✅ Deployment complete!"
echo "🌐 Opening your app..."
flyctl open

echo ""
echo "📊 View logs: flyctl logs"
echo "💻 SSH access: flyctl ssh console"
