-- ============================================
-- COMET MASTERMIND INTERACTIVE DATABASE SETUP
-- ============================================
-- Run this script in your Supabase SQL Editor
-- This will create all necessary tables for the interactive workbook

-- ============================================
-- 1. USER NOTES TABLE
-- ============================================
-- Stores user notes for each "YOUR NOTES" section
CREATE TABLE IF NOT EXISTS user_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    section_id VARCHAR(100) NOT NULL,
    note_content TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, section_id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_notes_user_id ON user_notes(user_id);
CREATE INDEX IF NOT EXISTS idx_user_notes_section_id ON user_notes(section_id);

-- Enable Row Level Security
ALTER TABLE user_notes ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own notes"
    ON user_notes FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own notes"
    ON user_notes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own notes"
    ON user_notes FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own notes"
    ON user_notes FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 2. USER PROMPTS TABLE
-- ============================================
-- Stores customized prompts when users edit them
CREATE TABLE IF NOT EXISTS user_prompts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    prompt_id VARCHAR(100) NOT NULL,
    custom_prompt TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, prompt_id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_prompts_user_id ON user_prompts(user_id);
CREATE INDEX IF NOT EXISTS idx_user_prompts_prompt_id ON user_prompts(prompt_id);

-- Enable Row Level Security
ALTER TABLE user_prompts ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own prompts"
    ON user_prompts FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own prompts"
    ON user_prompts FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own prompts"
    ON user_prompts FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own prompts"
    ON user_prompts FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 3. USER PROGRESS TABLE
-- ============================================
-- Tracks which sections users have viewed/completed and time spent
CREATE TABLE IF NOT EXISTS user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    section_id VARCHAR(100) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    time_spent INTEGER DEFAULT 0, -- in seconds
    last_accessed TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, section_id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_section_id ON user_progress(section_id);

-- Enable Row Level Security
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own progress"
    ON user_progress FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own progress"
    ON user_progress FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress"
    ON user_progress FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own progress"
    ON user_progress FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 4. ADMIN VIEW (For Admin Dashboard)
-- ============================================
-- Create a view that aggregates user data for admin access
CREATE OR REPLACE VIEW admin_user_overview AS
SELECT
    u.id as user_id,
    u.email,
    u.created_at as registered_at,
    u.last_sign_in_at,
    u.raw_user_meta_data->>'full_name' as full_name,
    COUNT(DISTINCT un.section_id) as notes_count,
    COUNT(DISTINCT up.prompt_id) as custom_prompts_count,
    COUNT(DISTINCT upg.section_id) as sections_viewed,
    COUNT(DISTINCT upg.section_id) FILTER (WHERE upg.completed = true) as sections_completed,
    SUM(upg.time_spent) as total_time_spent,
    MAX(upg.last_accessed) as last_activity
FROM auth.users u
LEFT JOIN user_notes un ON u.id = un.user_id
LEFT JOIN user_prompts up ON u.id = up.user_id
LEFT JOIN user_progress upg ON u.id = upg.user_id
GROUP BY u.id, u.email, u.created_at, u.last_sign_in_at, u.raw_user_meta_data;

-- ============================================
-- 5. FUNCTIONS FOR AUTO-UPDATE TIMESTAMPS
-- ============================================
-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for auto-updating timestamps
CREATE TRIGGER update_user_notes_updated_at
    BEFORE UPDATE ON user_notes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_prompts_updated_at
    BEFORE UPDATE ON user_prompts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 6. ADMIN CREDENTIALS TABLE
-- ============================================
-- Store admin passwords (hashed)
CREATE TABLE IF NOT EXISTS admin_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default admin (password: EdmundBogenAdmin2025!)
-- Note: In production, change this password immediately
INSERT INTO admin_credentials (username, password_hash)
VALUES ('admin', crypt('EdmundBogenAdmin2025!', gen_salt('bf')))
ON CONFLICT (username) DO NOTHING;

-- Enable Row Level Security for admin table
ALTER TABLE admin_credentials ENABLE ROW LEVEL SECURITY;

-- Only allow select (no modifications via client)
CREATE POLICY "Anyone can verify admin credentials"
    ON admin_credentials FOR SELECT
    TO authenticated, anon
    USING (true);

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- Next steps:
-- 1. Run this script in Supabase SQL Editor
-- 2. Verify all tables are created
-- 3. Test the RLS policies
-- 4. Update the admin password if needed

-- To verify tables were created, run:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
