-- =====================================================
-- FELDOR_HEALTH Database Schema
-- PostgreSQL schema for Supabase
-- Run this in Supabase SQL Editor
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLE: cases
-- Stores all uploaded scans, AI predictions, and reviews
-- =====================================================
CREATE TABLE IF NOT EXISTS cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id VARCHAR(255) NOT NULL,
    case_id VARCHAR(255) UNIQUE NOT NULL,
    module VARCHAR(50) NOT NULL CHECK (module IN ('breast', 'cervical')),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'approved', 'rejected')),

    -- Upload info
    original_filename VARCHAR(500),
    storage_path TEXT,
    file_type VARCHAR(50),
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- AI Results
    prediction VARCHAR(255),
    confidence FLOAT,
    risk_score FLOAT,
    risk_level VARCHAR(50) CHECK (risk_level IN ('low', 'medium', 'high')),
    findings JSONB DEFAULT '[]'::jsonb,
    review_required BOOLEAN DEFAULT TRUE,

    -- Model info
    model_version VARCHAR(100),
    processing_time_ms INTEGER,

    -- Review
    reviewer_id VARCHAR(255),
    review_date TIMESTAMP WITH TIME ZONE,
    review_notes TEXT,
    reviewer_status VARCHAR(50),

    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    audit_log JSONB DEFAULT '[]'::jsonb
);

-- =====================================================
-- TABLE: model_versions
-- Tracks available AI model versions
-- =====================================================
CREATE TABLE IF NOT EXISTS model_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module VARCHAR(50) NOT NULL,
    version VARCHAR(100) NOT NULL,
    name VARCHAR(255),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metrics JSONB DEFAULT '{}'::jsonb,
    UNIQUE (module, version)
);

-- =====================================================
-- TABLE: audit_logs
-- Immutable compliance audit trail
-- =====================================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL,
    user_id VARCHAR(255) DEFAULT 'system',
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    details JSONB DEFAULT '{}'::jsonb,
    ip_address VARCHAR(100)
);

-- =====================================================
-- INDEXES
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_cases_module ON cases(module);
CREATE INDEX IF NOT EXISTS idx_cases_status ON cases(status);
CREATE INDEX IF NOT EXISTS idx_cases_patient ON cases(patient_id);
CREATE INDEX IF NOT EXISTS idx_cases_upload_date ON cases(upload_date DESC);
CREATE INDEX IF NOT EXISTS idx_cases_review_required ON cases(review_required) WHERE review_required = TRUE;
CREATE INDEX IF NOT EXISTS idx_audit_case ON audit_logs(case_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action);

-- =====================================================
-- DEFAULT DATA: Model Versions
-- =====================================================
INSERT INTO model_versions (module, version, name, description, is_active)
VALUES
    ('breast', 'breast_v1', 'Breast AI v1', 'Initial breast cancer detection model', TRUE),
    ('breast', 'breast_v2', 'Breast AI v2', 'Enhanced breast cancer detection with improved localization', FALSE),
    ('cervical', 'cervical_v1', 'Cervical AI v1', 'Initial cervical cancer cytology model', TRUE)
ON CONFLICT (module, version) DO NOTHING
