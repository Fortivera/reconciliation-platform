-- ============================================================================
-- USERS AND AUTHENTICATION
-- ============================================================================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);

-- ============================================================================
-- RECONCILIATION SESSIONS
-- ============================================================================
CREATE TABLE reconciliation_sessions (
    id BIGSERIAL PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    period_start DATE,
    period_end DATE,
    status VARCHAR(50) NOT NULL,
    internal_file_path VARCHAR(500),
    bank_file_path VARCHAR(500),
    total_internal_transactions INTEGER DEFAULT 0,
    total_bank_transactions INTEGER DEFAULT 0,
    matched_count INTEGER DEFAULT 0,
    unmatched_count INTEGER DEFAULT 0,
    exception_count INTEGER DEFAULT 0,
    processing_time_ms BIGINT,
    created_by VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_session_status CHECK (status IN (
        'CREATED', 'UPLOADING', 'PROCESSING', 'REVIEW', 'COMPLETED', 'FAILED'
    ))
);

CREATE INDEX idx_sessions_session_id ON reconciliation_sessions(session_id);
CREATE INDEX idx_sessions_status ON reconciliation_sessions(status);
CREATE INDEX idx_sessions_created_by ON reconciliation_sessions(created_by);
CREATE INDEX idx_sessions_created_at ON reconciliation_sessions(created_at DESC);
CREATE INDEX idx_sessions_period ON reconciliation_sessions(period_start, period_end);

-- ============================================================================
-- TRANSACTIONS
-- ============================================================================
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    source VARCHAR(50) NOT NULL,
    transaction_date DATE NOT NULL,
    reference VARCHAR(100) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_type VARCHAR(50),
    description TEXT,
    normalized_description TEXT,
    is_matched BOOLEAN DEFAULT false,
    match_id BIGINT,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_transaction_source CHECK (source IN ('INTERNAL', 'BANK'))
);

CREATE INDEX idx_transactions_session_id ON transactions(session_id);
CREATE INDEX idx_transactions_session_source ON transactions(session_id, source);
CREATE INDEX idx_transactions_amount ON transactions(amount);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_amount_date ON transactions(amount, transaction_date);
CREATE INDEX idx_transactions_is_matched ON transactions(is_matched);
CREATE INDEX idx_transactions_match_id ON transactions(match_id);
CREATE INDEX idx_transactions_reference ON transactions(reference);
CREATE INDEX idx_transactions_source ON transactions(source);
CREATE INDEX idx_transactions_normalized_desc ON transactions(normalized_description);

-- ============================================================================
-- TRANSACTION MATCHES
-- ============================================================================
CREATE TABLE transaction_matches (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    internal_transaction_id BIGINT REFERENCES transactions(id) ON DELETE SET NULL,
    bank_transaction_id BIGINT REFERENCES transactions(id) ON DELETE SET NULL,
    status VARCHAR(50) NOT NULL,
    match_type VARCHAR(50) NOT NULL,
    confidence_score DECIMAL(5, 2),
    amount_match_score DECIMAL(5, 2),
    date_match_score DECIMAL(5, 2),
    description_match_score DECIMAL(5, 2),
    matched_by VARCHAR(100),
    matched_at TIMESTAMP,
    notes TEXT,
    is_partial_match BOOLEAN DEFAULT false,
    related_transaction_ids TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_match_status CHECK (status IN (
        'MATCHED', 'SUGGESTED', 'REJECTED', 'UNMATCHED', 'MANUAL', 'EXCEPTION'
    )),
    CONSTRAINT chk_match_type CHECK (match_type IN (
        'EXACT', 'FUZZY', 'PARTIAL', 'ML', 'MANUAL'
    )),
    CONSTRAINT chk_confidence_score CHECK (confidence_score >= 0 AND confidence_score <= 1),
    CONSTRAINT chk_amount_score CHECK (amount_match_score >= 0 AND amount_match_score <= 1),
    CONSTRAINT chk_date_score CHECK (date_match_score >= 0 AND date_match_score <= 1),
    CONSTRAINT chk_description_score CHECK (description_match_score >= 0 AND description_match_score <= 1)
);

CREATE INDEX idx_matches_session_id ON transaction_matches(session_id);
CREATE INDEX idx_matches_status ON transaction_matches(status);
CREATE INDEX idx_matches_match_type ON transaction_matches(match_type);
CREATE INDEX idx_matches_confidence ON transaction_matches(confidence_score DESC);
CREATE INDEX idx_matches_internal_txn ON transaction_matches(internal_transaction_id);
CREATE INDEX idx_matches_bank_txn ON transaction_matches(bank_transaction_id);
CREATE INDEX idx_matches_session_status ON transaction_matches(session_id, status);
CREATE INDEX idx_matches_is_partial ON transaction_matches(is_partial_match);

-- ============================================================================
-- EXCEPTIONS
-- ============================================================================
CREATE TABLE exceptions (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL REFERENCES reconciliation_sessions(id) ON DELETE CASCADE,
    transaction_id BIGINT REFERENCES transactions(id) ON DELETE SET NULL,
    exception_type VARCHAR(50) NOT NULL,
    priority VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    amount_discrepancy DECIMAL(15, 2),
    is_resolved BOOLEAN DEFAULT false,
    resolved_by VARCHAR(100),
    resolved_at TIMESTAMP,
    resolution_notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_exception_type CHECK (exception_type IN (
        'TIMING_DIFFERENCE', 'MISSING_TRANSACTION', 'AMOUNT_DISCREPANCY',
        'DUPLICATE_ENTRY', 'DATA_ERROR', 'BANK_FEE', 'OTHER'
    )),
    CONSTRAINT chk_exception_priority CHECK (priority IN ('HIGH', 'MEDIUM', 'LOW'))
);

CREATE INDEX idx_exceptions_session_id ON exceptions(session_id);
CREATE INDEX idx_exceptions_transaction_id ON exceptions(transaction_id);
CREATE INDEX idx_exceptions_type ON exceptions(exception_type);
CREATE INDEX idx_exceptions_priority ON exceptions(priority);
CREATE INDEX idx_exceptions_is_resolved ON exceptions(is_resolved);

-- ============================================================================
-- AUDIT LOGS
-- ============================================================================
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT NOT NULL,
    action VARCHAR(50) NOT NULL,
    changed_by VARCHAR(100),
    changes JSONB,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_audit_action CHECK (action IN (
        'CREATE', 'UPDATE', 'DELETE', 'APPROVE', 'REJECT',
        'UPLOAD', 'MATCH', 'RESOLVE', 'COMPLETE'
    ))
);

CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_action ON audit_logs(action);
CREATE INDEX idx_audit_created_at ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_changes ON audit_logs USING gin(changes);

-- ============================================================================
-- FUNCTION: auto-update updated_at
-- ============================================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON reconciliation_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_matches_updated_at BEFORE UPDATE ON transaction_matches
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_exceptions_updated_at BEFORE UPDATE ON exceptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
