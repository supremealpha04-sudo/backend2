-- =====================================================
-- CHUNK 2: Indexes
-- Run this SECOND in Supabase SQL Editor
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_cases_module ON cases(module);
CREATE INDEX IF NOT EXISTS idx_cases_status ON cases(status);
CREATE INDEX IF NOT EXISTS idx_cases_patient ON cases(patient_id);
CREATE INDEX IF NOT EXISTS idx_cases_upload_date ON cases(upload_date DESC);
CREATE INDEX IF NOT EXISTS idx_cases_review_required ON cases(review_required) WHERE review_required = TRUE;
CREATE INDEX IF NOT EXISTS idx_audit_case ON audit_logs(case_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action);
