-- Monitors table
CREATE TABLE monitors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  method VARCHAR(10) DEFAULT 'GET',
  interval INTEGER DEFAULT 300, -- seconds
  timeout INTEGER DEFAULT 10, -- seconds
  status VARCHAR(20) DEFAULT 'up', -- up, down, degraded
  uptime_percentage FLOAT DEFAULT 100,
  last_check TIMESTAMP WITH TIME ZONE,
  alert_email VARCHAR(255),
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Health checks table
CREATE TABLE health_checks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  monitor_id UUID NOT NULL REFERENCES monitors(id) ON DELETE CASCADE,
  status_code INTEGER,
  response_time INTEGER, -- milliseconds
  region VARCHAR(50),
  success BOOLEAN NOT NULL,
  error_message TEXT,
  checked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Alerts table
CREATE TABLE alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  monitor_id UUID NOT NULL REFERENCES monitors(id) ON DELETE CASCADE,
  type VARCHAR(20) NOT NULL, -- email, slack
  recipient VARCHAR(255) NOT NULL,
  triggered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  resolved_at TIMESTAMP WITH TIME ZONE,
  status VARCHAR(20) DEFAULT 'pending', -- pending, sent, failed
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Incidents table
CREATE TABLE incidents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  monitor_id UUID NOT NULL REFERENCES monitors(id) ON DELETE CASCADE,
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  resolved_at TIMESTAMP WITH TIME ZONE,
  duration INTEGER, -- seconds
  affected_regions TEXT[], -- array of regions
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_monitors_user_id ON monitors(user_id);
CREATE INDEX idx_monitors_status ON monitors(status);
CREATE INDEX idx_health_checks_monitor_id ON health_checks(monitor_id);
CREATE INDEX idx_health_checks_checked_at ON health_checks(checked_at DESC);
CREATE INDEX idx_alerts_monitor_id ON alerts(monitor_id);
CREATE INDEX idx_incidents_monitor_id ON incidents(monitor_id);

-- Enable Row Level Security
ALTER TABLE monitors ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE incidents ENABLE ROW LEVEL SECURITY;

-- RLS Policies for monitors
CREATE POLICY "Users can view their own monitors"
  ON monitors FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create monitors"
  ON monitors FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own monitors"
  ON monitors FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own monitors"
  ON monitors FOR DELETE
  USING (auth.uid() = user_id);

-- RLS Policies for health_checks (read-only for users)
CREATE POLICY "Users can view health checks for their monitors"
  ON health_checks FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM monitors
      WHERE monitors.id = health_checks.monitor_id
      AND monitors.user_id = auth.uid()
    )
  );

-- RLS Policies for alerts
CREATE POLICY "Users can view alerts for their monitors"
  ON alerts FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM monitors
      WHERE monitors.id = alerts.monitor_id
      AND monitors.user_id = auth.uid()
    )
  );

-- RLS Policies for incidents
CREATE POLICY "Users can view incidents for their monitors"
  ON incidents FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM monitors
      WHERE monitors.id = incidents.monitor_id
      AND monitors.user_id = auth.uid()
    )
  );

-- Enable Realtime for monitors and health_checks
ALTER PUBLICATION supabase_realtime ADD TABLE monitors;
ALTER PUBLICATION supabase_realtime ADD TABLE health_checks;
ALTER PUBLICATION supabase_realtime ADD TABLE alerts;
