-- =====================================================
-- CHUNK 3: Seed Data
-- Run this LAST in Supabase SQL Editor
-- =====================================================

INSERT INTO model_versions (module, version, name, description, is_active)
VALUES
    ('breast', 'breast_v1', 'Breast AI v1', 'Initial breast cancer detection model', TRUE),
    ('breast', 'breast_v2', 'Breast AI v2', 'Enhanced breast cancer detection with improved localization', FALSE),
    ('cervical', 'cervical_v1', 'Cervical AI v1', 'Initial cervical cancer cytology model', TRUE)
ON CONFLICT (module, version) DO NOTHING
