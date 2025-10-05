# 🗄️ Database Schema Documentation

## Overview

The Comet Mastermind Interactive uses Supabase (PostgreSQL) for data storage and user authentication. The database consists of 4 main tables with Row Level Security (RLS) policies to ensure data privacy.

## Tables

### 1. user_notes

Stores user-created notes for each "YOUR NOTES" section in the workbook.

```sql
CREATE TABLE user_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    section_id VARCHAR(100) NOT NULL,
    note_content TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, section_id)
);
```

**Columns:**
- `id`: Unique identifier (UUID)
- `user_id`: Foreign key to Supabase auth.users table
- `section_id`: Identifies which section (e.g., "getting-started", "use-case-1")
- `note_content`: User's actual notes (TEXT field, unlimited length)
- `created_at`: Timestamp when note was first created
- `updated_at`: Timestamp of last update (auto-updated via trigger)

**Indexes:**
- Primary key on `id`
- Index on `user_id` for fast user queries
- Index on `section_id` for section-based queries
- Unique constraint on `(user_id, section_id)` - one note per user per section

**RLS Policies:**
- Users can only SELECT, INSERT, UPDATE, DELETE their own notes
- Enforced via `auth.uid() = user_id` check

---

### 2. user_prompts

Stores customized prompts when users edit the default prompts.

```sql
CREATE TABLE user_prompts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    prompt_id VARCHAR(100) NOT NULL,
    custom_prompt TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, prompt_id)
);
```

**Columns:**
- `id`: Unique identifier (UUID)
- `user_id`: Foreign key to Supabase auth.users table
- `prompt_id`: Identifies which prompt (e.g., "prompt-use-case-1-0")
- `custom_prompt`: User's customized prompt text
- `created_at`: Timestamp when prompt was first customized
- `updated_at`: Timestamp of last update (auto-updated via trigger)

**Indexes:**
- Primary key on `id`
- Index on `user_id` for fast user queries
- Index on `prompt_id` for prompt-based queries
- Unique constraint on `(user_id, prompt_id)` - one custom prompt per user per prompt box

**RLS Policies:**
- Users can only SELECT, INSERT, UPDATE, DELETE their own prompts
- Enforced via `auth.uid() = user_id` check

---

### 3. user_progress

Tracks which sections users have viewed, time spent, and completion status.

```sql
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    section_id VARCHAR(100) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    time_spent INTEGER DEFAULT 0,
    last_accessed TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, section_id)
);
```

**Columns:**
- `id`: Unique identifier (UUID)
- `user_id`: Foreign key to Supabase auth.users table
- `section_id`: Identifies which section
- `completed`: Boolean flag for section completion (future feature)
- `time_spent`: Total time spent in seconds (accumulated)
- `last_accessed`: Timestamp of last time section was viewed
- `created_at`: Timestamp when section was first accessed

**Indexes:**
- Primary key on `id`
- Index on `user_id` for fast user queries
- Index on `section_id` for section-based queries
- Unique constraint on `(user_id, section_id)` - one progress record per user per section

**RLS Policies:**
- Users can only SELECT, INSERT, UPDATE, DELETE their own progress
- Enforced via `auth.uid() = user_id` check

**Time Tracking Logic:**
- Uses Intersection Observer API to detect when section is visible
- Accumulates time while section is in viewport
- Updates database when section leaves viewport
- Total time = sum of all viewing sessions

---

### 4. admin_credentials

Stores admin login credentials (hashed).

```sql
CREATE TABLE admin_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Columns:**
- `id`: Unique identifier (UUID)
- `username`: Admin username (unique)
- `password_hash`: Bcrypt hashed password
- `created_at`: Timestamp when admin was created

**Security:**
- Passwords are hashed using bcrypt (`crypt()` function with `bf` salt)
- Never store plain text passwords
- RLS policy allows SELECT only (for credential verification)

**Default Admin:**
- Username: `admin`
- Password: `EdmundBogenAdmin2025!` ⚠️ **CHANGE THIS IMMEDIATELY**

**To Change Password:**
```sql
UPDATE admin_credentials
SET password_hash = crypt('NewSecurePassword123!', gen_salt('bf'))
WHERE username = 'admin';
```

---

## Views

### admin_user_overview

Aggregated view for admin dashboard showing user statistics.

```sql
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
```

**Usage:**
```sql
SELECT * FROM admin_user_overview;
```

**Returns:**
- User identification (email, name)
- Activity metrics (notes, prompts, sections)
- Time tracking (total time spent)
- Last activity timestamp

---

## Triggers

### update_updated_at_column()

Automatically updates the `updated_at` timestamp on UPDATE operations.

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Applied to:**
- `user_notes` table
- `user_prompts` table

**Trigger Definition:**
```sql
CREATE TRIGGER update_user_notes_updated_at
    BEFORE UPDATE ON user_notes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_prompts_updated_at
    BEFORE UPDATE ON user_prompts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

---

## Row Level Security (RLS)

All tables have RLS enabled to ensure users can only access their own data.

### Policy Pattern

**For user_notes, user_prompts, user_progress:**

```sql
-- SELECT policy
CREATE POLICY "Users can view their own [data]"
    ON [table_name] FOR SELECT
    USING (auth.uid() = user_id);

-- INSERT policy
CREATE POLICY "Users can insert their own [data]"
    ON [table_name] FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- UPDATE policy
CREATE POLICY "Users can update their own [data]"
    ON [table_name] FOR UPDATE
    USING (auth.uid() = user_id);

-- DELETE policy
CREATE POLICY "Users can delete their own [data]"
    ON [table_name] FOR DELETE
    USING (auth.uid() = user_id);
```

**For admin_credentials:**

```sql
CREATE POLICY "Anyone can verify admin credentials"
    ON admin_credentials FOR SELECT
    TO authenticated, anon
    USING (true);
```

This allows credential verification but no modifications via client.

---

## Relationships

```
auth.users (Supabase Auth)
    ↓ (one-to-many)
user_notes
    - Stores user notes
    - CASCADE DELETE

auth.users
    ↓ (one-to-many)
user_prompts
    - Stores custom prompts
    - CASCADE DELETE

auth.users
    ↓ (one-to-many)
user_progress
    - Tracks section progress
    - CASCADE DELETE
```

**CASCADE DELETE:** When a user is deleted from auth.users, all their data is automatically removed.

---

## Indexes Strategy

### Current Indexes

1. **Primary Keys:** All tables have UUID primary keys (auto-indexed)
2. **Foreign Keys:** `user_id` columns indexed for JOIN performance
3. **Lookup Keys:** `section_id` and `prompt_id` indexed for filtering
4. **Unique Constraints:** Prevent duplicate entries per user/section

### Performance Considerations

**Good:**
- Fast user-specific queries (indexed user_id)
- Fast section lookups (indexed section_id)
- Unique constraints prevent data duplication

**Could Improve:**
- Add composite index on (user_id, section_id) for common queries
- Add partial index on completed sections: `WHERE completed = true`

### To Add Later (if needed):

```sql
-- Composite index for faster user+section queries
CREATE INDEX idx_user_progress_composite ON user_progress(user_id, section_id);

-- Partial index for completed sections
CREATE INDEX idx_user_progress_completed ON user_progress(user_id, section_id)
WHERE completed = true;
```

---

## Data Size Estimates

### Per User

| Table | Records | Size Estimate |
|-------|---------|--------------|
| user_notes | ~10 | ~50 KB |
| user_prompts | ~20 | ~100 KB |
| user_progress | ~10 | ~5 KB |
| **Total** | ~40 | **~155 KB** |

### At Scale

| Users | Total Records | Storage |
|-------|---------------|---------|
| 100 | 4,000 | 15.5 MB |
| 1,000 | 40,000 | 155 MB |
| 10,000 | 400,000 | 1.55 GB |

**Supabase Free Tier:** 500 MB database (supports ~3,000 users)

---

## Backup & Recovery

### Automated Backups (Supabase)

**Free Tier:**
- Daily backups
- 7-day retention
- Point-in-time recovery (within 7 days)

**Pro Tier:**
- Daily backups
- 30-day retention
- Point-in-time recovery (within 30 days)

### Manual Backup

**Export all data:**
```sql
-- Export as CSV
COPY (SELECT * FROM user_notes) TO '/path/to/user_notes.csv' CSV HEADER;
COPY (SELECT * FROM user_prompts) TO '/path/to/user_prompts.csv' CSV HEADER;
COPY (SELECT * FROM user_progress) TO '/path/to/user_progress.csv' CSV HEADER;
```

**Or use Admin Dashboard:**
- Click "Export All Data (CSV)"
- Saves complete dataset locally

### Restore from Backup

**Option 1: Supabase Dashboard**
- Go to Database → Backups
- Select backup date
- Click "Restore"

**Option 2: SQL Import**
```sql
-- Import from CSV
COPY user_notes FROM '/path/to/user_notes.csv' CSV HEADER;
COPY user_prompts FROM '/path/to/user_prompts.csv' CSV HEADER;
COPY user_progress FROM '/path/to/user_progress.csv' CSV HEADER;
```

---

## Common Queries

### Get User's All Data

```sql
-- Get all notes
SELECT * FROM user_notes WHERE user_id = 'user-uuid-here';

-- Get all custom prompts
SELECT * FROM user_prompts WHERE user_id = 'user-uuid-here';

-- Get progress
SELECT * FROM user_progress WHERE user_id = 'user-uuid-here';
```

### Admin Analytics

```sql
-- Total users
SELECT COUNT(*) FROM auth.users;

-- Active users (last 7 days)
SELECT COUNT(*) FROM auth.users
WHERE last_sign_in_at > NOW() - INTERVAL '7 days';

-- Total notes
SELECT COUNT(*) FROM user_notes;

-- Most active users
SELECT
    u.email,
    COUNT(DISTINCT un.section_id) as notes_count,
    SUM(upg.time_spent) as total_time
FROM auth.users u
LEFT JOIN user_notes un ON u.id = un.user_id
LEFT JOIN user_progress upg ON u.id = upg.user_id
GROUP BY u.id, u.email
ORDER BY total_time DESC
LIMIT 10;
```

### Clean Up Inactive Users

```sql
-- Find users with no activity in 90 days
SELECT email, last_sign_in_at
FROM auth.users
WHERE last_sign_in_at < NOW() - INTERVAL '90 days'
OR last_sign_in_at IS NULL;

-- Delete inactive users (CASCADE deletes their data)
-- ⚠️ BE CAREFUL - This is permanent!
DELETE FROM auth.users
WHERE last_sign_in_at < NOW() - INTERVAL '90 days';
```

---

## Migration Guide

### Adding New Columns

```sql
-- Add column to existing table
ALTER TABLE user_notes ADD COLUMN is_favorite BOOLEAN DEFAULT FALSE;

-- Add index if needed
CREATE INDEX idx_user_notes_favorite ON user_notes(user_id, is_favorite)
WHERE is_favorite = true;
```

### Modifying Columns

```sql
-- Change column type
ALTER TABLE user_progress ALTER COLUMN time_spent TYPE BIGINT;

-- Rename column
ALTER TABLE user_notes RENAME COLUMN note_content TO content;
```

### Adding New Tables

```sql
-- Create new table
CREATE TABLE user_bookmarks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    section_id VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, section_id)
);

-- Add RLS
ALTER TABLE user_bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their bookmarks"
    ON user_bookmarks
    USING (auth.uid() = user_id);
```

---

## Troubleshooting

### Issue: RLS Blocking Queries

**Symptom:** Empty results even though data exists

**Solution:**
```sql
-- Check if RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';

-- Temporarily disable RLS for testing (NOT FOR PRODUCTION!)
ALTER TABLE user_notes DISABLE ROW LEVEL SECURITY;

-- Re-enable after testing
ALTER TABLE user_notes ENABLE ROW LEVEL SECURITY;
```

### Issue: Slow Queries

**Symptom:** Dashboard takes long to load

**Solution:**
```sql
-- Analyze query performance
EXPLAIN ANALYZE
SELECT * FROM user_notes WHERE user_id = 'uuid-here';

-- Check for missing indexes
SELECT schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname = 'public';
```

### Issue: Unique Constraint Violations

**Symptom:** Error when saving notes/prompts

**Solution:**
```sql
-- Find duplicates
SELECT user_id, section_id, COUNT(*)
FROM user_notes
GROUP BY user_id, section_id
HAVING COUNT(*) > 1;

-- Remove duplicates (keep most recent)
DELETE FROM user_notes a USING user_notes b
WHERE a.id < b.id
AND a.user_id = b.user_id
AND a.section_id = b.section_id;
```

---

## Security Checklist

- ✅ RLS enabled on all tables
- ✅ Passwords hashed with bcrypt
- ✅ Foreign keys with CASCADE DELETE
- ✅ Unique constraints prevent duplicates
- ✅ Timestamps auto-updated
- ✅ Admin credentials table protected
- ⚠️ Change default admin password
- ⚠️ Regular backups enabled
- ⚠️ Monitor for SQL injection attempts

---

## Future Enhancements

### Phase 2: Analytics

```sql
-- User engagement score
CREATE TABLE user_engagement (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id),
    engagement_score INTEGER DEFAULT 0,
    last_calculated TIMESTAMPTZ DEFAULT NOW()
);
```

### Phase 3: Collaboration

```sql
-- Shared notes
CREATE TABLE shared_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    note_id UUID REFERENCES user_notes(id),
    shared_with UUID REFERENCES auth.users(id),
    permission VARCHAR(20) DEFAULT 'read'
);
```

### Phase 4: Versioning

```sql
-- Note history
CREATE TABLE note_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    note_id UUID REFERENCES user_notes(id),
    content TEXT,
    version INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Support

For database issues:
1. Check Supabase status: https://status.supabase.com
2. Review Supabase docs: https://supabase.com/docs
3. Contact: edmund@bogenhomes.com

---

**Last Updated:** October 2025
**Schema Version:** 1.0
