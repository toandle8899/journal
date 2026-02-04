# Journal App - Deployment Guide

## Quick Deploy to Fly.io (Recommended)

### Prerequisites
1. Install Fly CLI: `brew install flyctl` (macOS) or visit https://fly.io/docs/hands-on/install-flyctl/
2. Sign up for Fly.io account (free tier available)

### Deployment Steps

1. **Login to Fly.io**
   ```bash
   flyctl auth login
   ```

2. **Launch the app** (from the project directory)
   ```bash
   flyctl launch
   ```
   
   When prompted:
   - App name: Choose a unique name (e.g., `my-journal-app`)
   - Region: Choose closest to you
   - PostgreSQL: **No** (we're using SQLite)
   - Redis: **No**
   - Deploy now: **Yes**

3. **Set secrets**
   ```bash
   flyctl secrets set SECRET_KEY_BASE=$(mix phx.gen.secret)
   flyctl secrets set TOKEN_SIGNING_SECRET=$(mix phx.gen.secret)
   ```

4. **Deploy**
   ```bash
   flyctl deploy
   ```

5. **Open your app**
   ```bash
   flyctl open
   ```

Your app will be available at: `https://your-app-name.fly.dev`

## Alternative: Gigalixir

1. Install Gigalixir CLI:
   ```bash
   pip3 install gigalixir
   ```

2. Sign up and login:
   ```bash
   gigalixir signup
   gigalixir login
   ```

3. Create app:
   ```bash
   gigalixir create
   ```

4. Deploy:
   ```bash
   git push gigalixir main
   ```

## Alternative: Render.com

1. Create account at https://render.com
2. Create new "Web Service"
3. Connect your GitHub repository
4. Configure:
   - Build Command: `mix deps.get && mix assets.deploy && mix phx.digest`
   - Start Command: `mix phx.server`
   - Add environment variables:
     - `SECRET_KEY_BASE`: Generate with `mix phx.gen.secret`
     - `TOKEN_SIGNING_SECRET`: Generate with `mix phx.gen.secret`
     - `DATABASE_PATH`: `/var/data/journal.db`
     - `PHX_HOST`: Your render URL (e.g., `my-journal.onrender.com`)

## Important Notes

- **SQLite in Production**: SQLite works for single-instance deployments. For multi-instance, consider PostgreSQL.
- **Data Persistence**: Ensure your deployment platform supports persistent volumes for SQLite database.
- **Environment Variables**: Never commit secrets to git. Use platform-specific secret management.

## Test Credentials

After deployment, create a test user:
- Email: demo@journal.com
- Password: demo12345678

## Troubleshooting

If deployment fails:
1. Check logs: `flyctl logs` (Fly.io) or platform-specific command
2. Verify all secrets are set
3. Ensure database migrations run: `flyctl ssh console -C "mix ecto.migrate"`
