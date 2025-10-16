-- Flyway Migration: V2__add_user_sessions_and_permissions.sql
-- Adds user session tracking and multi-user reconciliation support

-- User web sessions (JWT token tracking, optional)
CREATE TABLE user_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(500) NOT NULL UNIQUE,
    refresh_token VARCHAR(500),
    ip_address VARCHAR(50),
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    refresh_expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logged_out_at TIMESTAMP
);

CREATE INDEX idx_user_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_user_sessions_refresh ON user_sessions(refresh_token);
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_expires ON user_sessions(expires_at);
CREATE INDEX idx_user_sessions_active ON user_sessions(is_active);

-- Reconciliation session permissions (multi-user collaboration)
CREATE TABLE session_permissions (
    id BIGSERIAL PRIMARY KEY,
    reconciliation_session_id BIGINT NOT NULL REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission_level VARCHAR(50) NOT NULL, -- OWNER, EDITOR, VIEWER
    can_approve_matches BOOLEAN DEFAULT false,
    can_edit_transactions BOOLEAN DEFAULT false,
    can_complete_session BOOLEAN DEFAULT false,
    granted_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(reconciliation_session_id, user_id)
);

CREATE INDEX idx_session_permissions_session ON session_permissions(reconciliation_session_id);
CREATE INDEX idx_session_permissions_user ON session_permissions(user_id);
CREATE INDEX idx_session_permissions_level ON session_permissions(permission_level);

-- Activity log for audit trail (who did what)
CREATE TABLE activity_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    reconciliation_session_id BIGINT REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    action_type VARCHAR(100) NOT NULL, -- LOGIN, UPLOAD_FILE, APPROVE_MATCH, etc.
    entity_type VARCHAR(50), -- MATCH, TRANSACTION, EXCEPTION
    entity_id BIGINT,
    description TEXT,
    metadata JSONB, -- Additional context
    ip_address VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activity_logs_user ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_session ON activity_logs(reconciliation_session_id);
CREATE INDEX idx_activity_logs_action ON activity_logs(action_type);
CREATE INDEX idx_activity_logs_created ON activity_logs(created_at DESC);
CREATE INDEX idx_activity_logs_metadata ON activity_logs USING gin(metadata);

-- User preferences (UI settings, notification preferences)
CREATE TABLE user_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    fuzzy_match_threshold DECIMAL(3, 2) DEFAULT 0.85,
    date_tolerance_days INTEGER DEFAULT 3,
    auto_approve_high_confidence BOOLEAN DEFAULT false,
    email_notifications BOOLEAN DEFAULT true,
    notification_frequency VARCHAR(20) DEFAULT 'REALTIME', -- REALTIME, DAILY, WEEKLY
    theme VARCHAR(20) DEFAULT 'LIGHT',
    preferences JSONB, -- Flexible JSON for additional settings
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_preferences_user ON user_preferences(user_id);

-- Notification queue (for email/push notifications)
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reconciliation_session_id BIGINT REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL, -- MATCH_READY, EXCEPTION_FOUND, SESSION_COMPLETED
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL', -- LOW, NORMAL, HIGH
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    sent_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);
CREATE INDEX idx_notifications_type ON notifications(notification_type);

-- Comments on reconciliation items (for collaboration)
CREATE TABLE reconciliation_comments (
    id BIGSERIAL PRIMARY KEY,
    reconciliation_session_id BIGINT NOT NULL REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    entity_type VARCHAR(50) NOT NULL, -- MATCH, TRANSACTION, EXCEPTION
    entity_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    comment TEXT NOT NULL,
    parent_comment_id BIGINT REFERENCES reconciliation_comments(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_comments_session ON reconciliation_comments(reconciliation_session_id);
CREATE INDEX idx_comments_entity ON reconciliation_comments(entity_type, entity_id);
CREATE INDEX idx_comments_user ON reconciliation_comments(user_id);
CREATE INDEX idx_comments_parent ON reconciliation_comments(parent_comment_id);

-- Add created_by foreign key to reconciliation_sessions
ALTER TABLE reconciliation_sessions
ADD COLUMN created_by_id BIGINT REFERENCES users(id) ON DELETE SET NULL;

CREATE INDEX idx_sessions_created_by_id ON reconciliation_sessions(created_by_id);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Add triggers for updated_at
CREATE TRIGGER update_user_sessions_updated_at BEFORE UPDATE ON user_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_session_permissions_updated_at BEFORE UPDATE ON session_permissions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at BEFORE UPDATE ON user_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reconciliation_comments_updated_at BEFORE UPDATE ON reconciliation_comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE user_sessions IS 'Tracks active user login sessions for JWT token management';
COMMENT ON TABLE session_permissions IS 'Multi-user access control for reconciliation sessions';
COMMENT ON TABLE activity_logs IS 'Complete audit trail of all user actions';
COMMENT ON TABLE user_preferences IS 'User-specific settings and preferences';
COMMENT ON TABLE notifications IS 'In-app and email notification queue';
COMMENT ON TABLE reconciliation_comments IS 'Collaboration comments on matches/transactions/exceptions';