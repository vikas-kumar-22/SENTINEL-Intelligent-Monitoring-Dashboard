# Sentinel - Complete Documentation

A modern, lightweight uptime monitoring application built with Vue 3, Vite, and Supabase.

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Setup & Installation](#setup--installation)
4. [Authentication](#authentication)
5. [Monitor Management](#monitor-management)
6. [Alert System](#alert-system)
7. [UI Components](#ui-components)
8. [Database Schema](#database-schema)
9. [API Reference](#api-reference)
10. [Troubleshooting](#troubleshooting)

---

## Features

### Core Monitoring
- **Real-time Monitoring** - Monitor HTTP endpoints with configurable intervals (30s, 60s, 2m, 5m)
- **Response Time Tracking** - Track min, max, average, median, and P95 response times
- **Status Indicators** - Visual indicators for monitor status (up/down/degraded)
- **SSL Certificate Monitoring** - Check SSL certificate expiry dates with fallback mechanisms

### Dashboard & Analytics
- **Dashboard Overview** - Real-time status of all monitors
- **7-Day History** - Uptime history with N/A for days without data
- **Detailed Analytics** - Total checks, successful/failed checks, response time stats
- **Response Time Charts** - Visual charts of response times over time
- **Uptime Percentages** - 24-hour and 30-day uptime calculations

### Alert System
- **Downtime Alerts** - Configurable threshold-based alerts
- **Multiple Channels** - Browser notifications and email alerts
- **Per-Monitor Email** - Set custom alert email per monitor
- **Alert History** - View all alerts with timestamps
- **Alert Management** - Dismiss and clear alerts

### Authentication
- **Email/Password** - Secure login with email and password
- **OAuth Support** - Sign in with Google or GitHub
- **Session Management** - Automatic session handling with Supabase
- **User Profiles** - User settings and preferences

### UI/UX
- **Professional Design** - Modern dark theme with emerald accents
- **SVG Icons** - Professional iconography throughout
- **Responsive Layout** - Works on desktop and mobile
- **Compact Design** - Optimized spacing and typography
- **Custom Modals** - In-app confirmation dialogs

---

## Tech Stack

### Frontend
- **Vue 3** - Progressive JavaScript framework
- **Vite** - Next-generation build tool
- **Tailwind CSS** - Utility-first CSS framework
- **Chart.js** - JavaScript charting library

### Backend & Services
- **Supabase** - Open-source Firebase alternative
  - PostgreSQL database
  - Authentication (Email/OAuth)
  - Real-time subscriptions
  - Edge Functions (for email alerts)

### Libraries
- **Axios** - HTTP client for API requests
- **Vue Router** - Client-side routing
- **Pinia** - State management
- **date-fns** - Date utility library

---

## Setup & Installation

### Prerequisites
- Node.js >= 16
- npm or yarn
- Supabase account (free tier available)

### Installation Steps

1. **Clone and Install**
```bash
cd sentinel
npm install
```

2. **Environment Configuration**
```bash
cp .env.example .env
```

3. **Add Supabase Credentials**
```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. **Database Setup**
- Create tables in Supabase:
  - `users` - User profiles
  - `monitors` - Monitor configurations
  - `health_checks` - Health check records
  - `alerts` - Alert history

5. **Run Development Server**
```bash
npm run dev
```

6. **Build for Production**
```bash
npm run build
```

---

## Authentication

### Email/Password Login
- Users register with email and password
- Passwords are securely hashed by Supabase
- Session tokens stored in localStorage
- Automatic logout on session expiry

### OAuth Integration
- **Google OAuth** - Sign in with Google account
- **GitHub OAuth** - Sign in with GitHub account
- Automatic user profile creation
- Email verification not required for OAuth

### Session Management
- Tokens stored securely
- Automatic refresh on page load
- Logout clears all session data
- Protected routes require authentication

---

## Monitor Management

### Creating Monitors
1. Click "Add Monitor" button
2. Enter monitor details:
   - **Name** - Display name for the monitor
   - **URL** - HTTP/HTTPS endpoint to monitor
   - **Interval** - Check frequency (30s, 60s, 2m, 5m)
   - **Alert Email** - Email for downtime alerts (optional)
3. Click "Create Monitor"

### Editing Monitors
1. Select monitor from dashboard
2. Click "Edit" button
3. Modify details:
   - Name
   - URL
   - Check interval
   - Alert email
4. Click "Save Changes"

### Deleting Monitors
1. Select monitor from dashboard
2. Click "Delete" button
3. Confirm deletion in modal dialog
4. All associated data is deleted

### Monitor Status
- **Up** - Endpoint responding with 2xx status
- **Down** - Endpoint not responding or error status
- **Degraded** - Slow response times or intermittent issues
- **Paused** - Monitor temporarily disabled

---

## Alert System

### Alert Configuration

**Alert Settings:**
- Enable/disable alerts globally
- Set downtime threshold (minutes before alert)
- Choose alert channels:
  - Browser notifications
  - Email alerts

**Per-Monitor Configuration:**
- Set custom alert email per monitor
- Falls back to user email if not set
- Can be updated in monitor edit form

### Alert Types

**Downtime Alerts:**
- Triggered when monitor is down for threshold duration
- Includes monitor name, URL, and downtime duration
- Sent via enabled channels

**Alert Channels:**

1. **Browser Notifications**
   - Requires user permission
   - Shows in browser notification center
   - Includes alert details

2. **Email Alerts**
   - Sent to monitor's alert email or user email
   - Includes monitor status and details
   - Sent via Supabase Edge Functions

### Alert Management
- View all alerts in Alerts Panel
- Dismiss individual alerts
- Clear all alerts at once
- Alerts show timestamp and monitor name

---

## Database Schema

### Users Table
```sql
- id (UUID, primary key)
- email (text, unique)
- created_at (timestamp)
- updated_at (timestamp)
```

### Monitors Table
```sql
- id (UUID, primary key)
- user_id (UUID, foreign key)
- name (text)
- url (text)
- interval (integer, seconds)
- status (text: 'up', 'down', 'degraded', 'paused')
- response_time (integer, milliseconds)
- last_check (timestamp)
- alert_email (text, optional)
- created_at (timestamp)
- updated_at (timestamp)
```

### Health Checks Table
```sql
- id (UUID, primary key)
- monitor_id (UUID, foreign key)
- user_id (UUID, foreign key)
- success (boolean)
- response_time (integer, milliseconds)
- status_code (integer)
- error_message (text, optional)
- checked_at (timestamp)
```

### Alerts Table
```sql
- id (UUID, primary key)
- monitor_id (UUID, foreign key)
- user_id (UUID, foreign key)
- type (text: 'downtime', 'ssl', 'error')
- message (text)
- read (boolean)
- created_at (timestamp)
```

---

## API Reference

### Monitors Store (Pinia)

#### Methods

**fetchMonitors()**
- Fetches all monitors for current user
- Returns: Promise<void>

**createMonitor(data)**
- Creates new monitor
- Parameters: { name, url, interval, alert_email }
- Returns: Promise<void>

**updateMonitor(id, data)**
- Updates monitor details
- Parameters: id (UUID), data (partial monitor object)
- Returns: Promise<void>

**deleteMonitor(id)**
- Deletes monitor and associated data
- Parameters: id (UUID)
- Returns: Promise<void>

**pauseMonitor(id)**
- Pauses monitoring for a monitor
- Parameters: id (UUID)
- Returns: Promise<void>

**resumeMonitor(id)**
- Resumes monitoring for a monitor
- Parameters: id (UUID)
- Returns: Promise<void>

**checkMonitorNow(id)**
- Performs immediate health check
- Parameters: id (UUID)
- Returns: Promise<void>

#### Computed Properties

**monitors**
- Returns: Array of all monitors

**state**
- Returns: Reactive state object with monitors, health checks, alerts

#### Getters

**getUptimeHistory(monitorId, days)**
- Returns uptime history for specified days
- Days without data show N/A
- Returns: Object with date keys and uptime data

**getResponseTimeStats(monitorId)**
- Returns response time statistics
- Returns: { avg, min, max, median, p95 }

**getDetailedAnalytics(monitorId)**
- Returns detailed analytics
- Returns: { totalChecks, successfulChecks, failedChecks, ... }

**calculateUptimePercentage(monitorId)**
- Calculates overall uptime percentage
- Returns: Number (0-100)

---

## Troubleshooting

### Common Issues

**1. Monitors Not Appearing**
- Check Supabase connection
- Verify user is authenticated
- Check browser console for errors
- Ensure monitors are created in correct user account

**2. Health Checks Not Recording**
- Verify monitor URL is accessible
- Check network connectivity
- Review Supabase Edge Functions logs
- Check monitor interval setting

**3. Alerts Not Sending**
- Verify alert settings are enabled
- Check alert email configuration
- Review Supabase Edge Functions
- Check browser notification permissions

**4. SSL Certificate Shows N/A**
- SSL Labs API may be rate-limited
- Fallback HTTPS check is used
- Wait a few minutes and try again
- Check monitor URL is HTTPS

**5. Dashboard Not Loading**
- Clear browser cache
- Check Supabase credentials
- Verify authentication token
- Check browser console for errors

### Debug Mode

Enable logging in browser console:
```javascript
// In stores/monitors.js
console.log('Debug info:', state)
```

### Performance Tips

- Limit number of monitors (50+)
- Use longer check intervals for less critical services
- Archive old health check data periodically
- Use browser dev tools to monitor performance

---

## Best Practices

### Monitor Configuration
- Use meaningful monitor names
- Set appropriate check intervals
- Configure alert emails for important services
- Regularly review and update monitor list

### Alert Management
- Set reasonable downtime thresholds
- Enable appropriate alert channels
- Review alerts regularly
- Clear resolved alerts

### Security
- Use strong passwords
- Enable OAuth where possible
- Keep Supabase credentials secure
- Regularly review access logs

### Maintenance
- Backup important monitor configurations
- Review analytics regularly
- Update monitor URLs when services move
- Archive old data periodically

---

## Support & Feedback

For issues, questions, or feature requests:
1. Check troubleshooting section
2. Review browser console for errors
3. Check Supabase dashboard for database issues
4. Contact support with error details

---

## Version History

### Current Version
- Professional UI with SVG icons
- Custom confirmation modals
- Alerts panel with outside click detection
- 7-day history with N/A for missing data
- Per-monitor alert email configuration
- SSL certificate monitoring with fallback
- Comprehensive analytics and charts

### Recent Updates
- Fixed UI alignment between Dashboard and MonitorDetail
- Improved alerts panel UX
- Added custom confirmation modals
- Enhanced 7-day history display
- Professional icon system

---

## License

MIT License - See LICENSE file for details

---

**Last Updated:** November 19, 2025
**Status:** Production Ready ✅
