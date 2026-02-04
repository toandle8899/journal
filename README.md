# 📖 Journal - Vintage Library Card Catalog

A beautiful, distinctive journal application with a vintage library card catalog aesthetic. Built with Phoenix LiveView, Ash Framework, and deployed on Fly.io.

## 🌐 Live Demo

**Production URL**: [https://journal-weathered-breeze-4632.fly.dev/](https://journal-weathered-breeze-4632.fly.dev/)

## ✨ Features

### Core Functionality
- 🔐 **Full Authentication System** - Secure email/password authentication with Ash Authentication
- 📝 **Journal Entry Management** - Create, read, update, and delete journal entries
- 🔒 **Privacy** - Each user can only see and manage their own entries
- 💾 **Persistent Storage** - SQLite database with automatic backups

### Design Highlights
- 🎨 **Vintage Library Aesthetic** - Inspired by classic library card catalogs
- 🖋️ **Distinctive Typography**:
  - **EB Garamond** for body text
  - **Libre Baskerville** for headings
  - **Courier Prime** for monospace elements
- 🎭 **Rich Color Palette** - Sepia tones with vintage brass and oxidized copper accents
- ✨ **Smooth Animations** - Staggered card reveals and micro-interactions
- 📄 **Atmospheric Backgrounds** - Layered paper textures with subtle noise
- 📱 **Responsive Design** - Works beautifully on all devices

## 🚀 Tech Stack

- **Framework**: [Phoenix 1.8.3](https://www.phoenixframework.org/) with LiveView
- **Backend**: [Ash Framework 3.14.1](https://ash-hq.org/) - Resource-based framework
- **Authentication**: [Ash Authentication 4.13.7](https://hexdocs.pm/ash_authentication)
- **Database**: SQLite with [AshSqlite 0.2.15](https://hexdocs.pm/ash_sqlite)
- **Styling**: Tailwind CSS v4 + DaisyUI
- **Deployment**: [Fly.io](https://fly.io)
- **Language**: Elixir 1.19.5 / OTP 28

## 📦 Installation

### Prerequisites
- Elixir 1.19.5 or later
- Erlang/OTP 28 or later
- Node.js (for asset compilation)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/toandle8899/journal.git
   cd journal
   ```

2. **Install dependencies**
   ```bash
   mix deps.get
   cd assets && npm install && cd ..
   ```

3. **Set up the database**
   ```bash
   mix ash.setup
   ```

4. **Start the Phoenix server**
   ```bash
   mix phx.server
   ```

5. **Visit** [`localhost:4000`](http://localhost:4000)

## 🎨 Design Philosophy

This journal breaks away from generic AI-generated aesthetics by:

- **Avoiding common patterns**: No Inter/Roboto fonts, no purple gradients, no cookie-cutter layouts
- **Embracing uniqueness**: Vintage library card catalog metaphor with authentic typography
- **Creating atmosphere**: Layered backgrounds, subtle textures, and thoughtful color choices
- **Delighting users**: Staggered animations, hover effects, and micro-interactions

## 🏗️ Project Structure

```
journal/
├── lib/
│   ├── journal/
│   │   ├── accounts/          # User authentication domain
│   │   └── journals/          # Journal entries domain
│   └── journal_web/
│       ├── controllers/       # Auth controllers
│       ├── live/             # LiveView components
│       │   ├── auth_live/    # Sign in/Register
│       │   └── journal_live/ # Journal CRUD
│       └── router.ex         # Route definitions
├── assets/
│   ├── css/                  # Tailwind + custom styles
│   └── js/                   # Phoenix LiveView hooks
├── priv/
│   └── repo/migrations/      # Database migrations
├── Dockerfile                # Production container
├── fly.toml                  # Fly.io configuration
└── DEPLOYMENT.md            # Deployment guide
```

## 🚢 Deployment

### Deploy to Fly.io

1. **Install Fly CLI**
   ```bash
   brew install flyctl
   ```

2. **Login to Fly.io**
   ```bash
   flyctl auth login
   ```

3. **Run the deployment script**
   ```bash
   ./deploy.sh
   ```

Or follow the detailed guide in [`DEPLOYMENT.md`](./DEPLOYMENT.md)

## 🔧 Configuration

### Environment Variables

Required for production:
- `SECRET_KEY_BASE` - Phoenix secret key (generate with `mix phx.gen.secret`)
- `TOKEN_SIGNING_SECRET` - Authentication token secret
- `DATABASE_PATH` - Path to SQLite database file
- `PHX_HOST` - Your production hostname

### Local Development

Configuration is in `config/dev.exs`. The token signing secret is set in `config/config.exs` for development.

## 📝 Usage

1. **Register** - Create an account at `/register`
2. **Sign In** - Login at `/sign-in`
3. **Create Entries** - Click the vintage stamp "+" button
4. **Edit/Delete** - Hover over entries to see actions
5. **Sign Out** - Click "Exit" in the header

## 🧪 Testing

```bash
# Run all tests
mix test

# Run with coverage
mix test --cover
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- **Phoenix Framework** - For the excellent web framework
- **Ash Framework** - For the powerful resource-based architecture
- **Fly.io** - For seamless deployment
- **Google Fonts** - For the beautiful typography

## 📧 Contact

- **Author**: Duc Toan Le
- **Email**: duc-toan.le@hsrw.org
- **GitHub**: [@toandle8899](https://github.com/toandle8899)

---

**Live App**: [https://journal-weathered-breeze-4632.fly.dev/](https://journal-weathered-breeze-4632.fly.dev/)

Made with ❤️ using Phoenix LiveView and Ash Framework
