# Sentinel - Quick Start Guide

## 5-Minute Setup

### 1. Install Dependencies
```bash
cd sentinel
npm install
```

### 2. Create .env File
```bash
cp .env.example .env
```

### 3. Add Supabase Credentials
Edit `.env` and add:
```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

Get these from Supabase dashboard → Settings → API

### 4. Set Up Database
1. Go to Supabase SQL Editor
2. Copy and paste contents of `DATABASE_SCHEMA.sql`
3. Run the SQL

### 5. Start Development Server
```bash
npm run dev
```

Visit `http://localhost:5173`

## First Time Login

### Option 1: Email/Password
1. Click "Sign up"
2. Enter email and password
3. Check email for confirmation link
4. Click link to confirm
5. Login with credentials

### Option 2: Google (Optional)
1. Set up Google OAuth (see OAUTH_SETUP.md)
2. Click "Google" button
3. Authenticate with Google
4. Authorize app

### Option 3: GitHub (Optional)
1. Set up GitHub OAuth (see OAUTH_SETUP.md)
2. Click "GitHub" button
3. Authenticate with GitHub
4. Authorize app

## Create Your First Monitor

1. Click "+ New Monitor"
2. Fill in details:
   - **Name**: My Website
   - **URL**: https://example.com
   - **Method**: GET
   - **Interval**: 300 (5 minutes)
   - **Timeout**: 10 (seconds)
3. Click "Create Monitor"

## View Dashboard

- See all monitors and their status
- View uptime percentage
- Check response times
- Click on monitor for details

## Next Steps

- Configure OAuth (OAUTH_SETUP.md)
- Set up alerts (coming soon)
- Deploy to production (README.md)
- Customize monitoring intervals

## Troubleshooting

**Can't login?**
- Check email confirmation
- Verify Supabase credentials in .env
- Check browser console for errors

**Monitor not checking?**
- Verify URL is accessible
- Check timeout setting
- Review browser console

**OAuth not working?**
- Verify redirect URLs match
- Check OAuth credentials in Supabase
- See OAUTH_SETUP.md for details

## Support

- Full setup guide: SETUP_GUIDE.md
- OAuth guide: OAUTH_SETUP.md
- Database schema: DATABASE_SCHEMA.sql
- README: README.md
