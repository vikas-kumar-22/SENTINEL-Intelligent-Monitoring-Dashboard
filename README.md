# Sentinel - Uptime Monitoring

A modern, lightweight uptime monitoring application built with Vue 3, Vite, and Supabase.

## Features

- **Real-time Monitoring** - Monitor HTTP endpoints with configurable intervals
- **Dashboard** - Overview of all monitors with status and uptime stats
- **Authentication** - Secure login with Supabase (Email/Password + OAuth)
- **OAuth Support** - Sign in with Google or GitHub
- **Response Time Tracking** - Track response times for each monitor
- **Health Checks** - Detailed health check history and analytics
- **Status Badges** - Visual indicators for monitor status (up/down/degraded)
- **Modern UI** - Built with Tailwind CSS for a clean, responsive interface

## Tech Stack

- **Frontend**: Vue 3, Vite, Tailwind CSS
- **Backend**: Supabase (Authentication & Database)
- **HTTP Client**: Axios
- **Charts**: Chart.js & Vue-ChartJS
- **Date Handling**: date-fns

## Setup

### Prerequisites

- Node.js >= 16
- npm or yarn
- Supabase account (free tier available at https://supabase.com)

### Installation

1. Clone the repository
```bash
cd sentinel
npm install
```

2. Create `.env` file with your Supabase credentials
```bash
cp .env.example .env
```

3. Add your Supabase URL and Anon Key to `.env`
```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Set up Supabase database tables (use the provided SQL schema)

5. Configure OAuth providers in Supabase:
   - Go to Authentication → Providers
   - Enable Google OAuth:
     - Create OAuth credentials at https://console.cloud.google.com
     - Add Authorized redirect URIs: `https://your-supabase-url/auth/v1/callback?provider=google`
   - Enable GitHub OAuth:
     - Create OAuth app at https://github.com/settings/developers
     - Add Authorization callback URL: `https://your-supabase-url/auth/v1/callback?provider=github`

### Development

```bash
npm run dev
```

Visit `http://localhost:5173`

### Build

```bash
npm run build
```

## Usage

1. **Sign Up** - Create a new account
2. **Create Monitor** - Add a new monitor with URL and check interval
3. **View Dashboard** - See all monitors and their status
4. **Check Details** - Click on a monitor to see detailed stats
5. **Manual Check** - Click "Check Now" to manually trigger a check

## Project Structure

```
src/
├── pages/           # Vue page components
├── stores/          # State management (auth, monitors)
├── lib/             # Utilities (Supabase client)
├── App.vue          # Root component
├── main.js          # Entry point
├── router.js        # Vue Router configuration
└── style.css        # Global styles
```

## License

MIT
