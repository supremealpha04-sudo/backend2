-- =====================================================
-- CHUNK 1: Extensions and Tables
-- Run this FIRST in Supabase SQL Editor
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- TABLE: cases
CREATE TABLE IF NOT EXISTS cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id VARCHAR(255) NOT NULL,
    case_id VARCHAR(255) UNIQUE NOT NULL,
    module VARCHAR(50) NOT NULL CHECK (module IN ('breast', 'cervical')),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'approved', 'rejected')),
    original_filename VARCHAR(500),
    storage_path TEXT,
    file_type VARCHAR(50),
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    prediction VARCHAR(255),
    confidence FLOAT,
    risk_score FLOAT,
    risk_level VARCHAR(50) CHECK (risk_level IN ('low', 'medium', 'high')),
    findings JSONB DEFAULT '[]'::jsonb,
    review_required BOOLEAN DEFAULT TRUE,
    model_version VARCHAR(100),
    processing_time_ms INTEGER,
    reviewer_id VARCHAR(255),
    review_date TIMESTAMP WITH TIME ZONE,
    review_notes TEXT,
    reviewer_status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    audit_log JSONB DEFAULT '[]'::jsonb
);

-- TABLE: model_versions
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

-- TABLE: audit_logs
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL,
    user_id VARCHAR(255) DEFAULT 'system',
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    details JSONB DEFAULT '{}'::jsonb,
    ip_address VARCHAR(100)
);
