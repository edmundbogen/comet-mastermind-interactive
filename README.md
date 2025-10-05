# 🚀 Comet Mastermind - Interactive Workbook

An interactive, cloud-based workbook for real estate professionals to master Comet Browser and AI-powered workflows. Built with Supabase for real-time data sync and user progress tracking.

## ✨ Features

### For Students/Users

#### 📝 **Interactive Notes**
- All "YOUR NOTES" sections are fully editable
- Auto-save functionality (saves 2 seconds after you stop typing)
- Visual save indicators (Saving... / Saved ✓)
- Notes persist across sessions and devices
- Mobile-responsive design

#### ✏️ **Customizable Prompts**
- Edit any prompt box to customize for your specific use case
- Save your customized prompts to your account
- Reuse your personalized prompts anytime
- Share-worthy templates you can refine over time

#### 📊 **Progress Tracking**
- Visual progress bar showing completion percentage
- Automatic tracking of sections viewed
- Time spent monitoring per section
- See your learning journey at a glance

#### 📥 **Download Your Workbook**
- Download your complete workbook with all notes and prompts
- Exports as a clean HTML file with your name and date
- Can be converted to PDF using browser print function
- Perfect for offline reference or printing

#### 🔐 **Secure Authentication**
- Email/password authentication via Supabase
- Password reset functionality
- Secure session management
- Your data is private and encrypted

### For Administrators

#### 📊 **Admin Dashboard**
Access at: `/admin-dashboard.html`

**Password:** `EdmundBogenAdmin2025!` ⚠️ *Change this immediately in production!*

**Features:**
- 📈 Real-time statistics dashboard
  - Total users
  - Active users this week
  - Total notes created
  - Custom prompts saved

- 👥 User Management
  - View all registered users
  - See user activity and engagement
  - Track last login times
  - Monitor progress per user

- 📝 Content Insights
  - View all user notes by section
  - See customized prompts
  - Track time spent per section
  - Identify engaged vs. inactive users

- 📥 Export Functionality
  - Download all user data as CSV
  - Includes notes, prompts, and progress
  - Easy import to Excel/Google Sheets
  - Compliance and backup ready

## 🗄️ Database Setup

### Step 1: Run SQL Migration

1. Log into your Supabase project: https://app.supabase.com
2. Navigate to: **SQL Editor**
3. Open the file: `database-setup.sql`
4. Copy and paste the entire SQL script
5. Click **RUN** to execute

This creates:
- ✅ `user_notes` table
- ✅ `user_prompts` table
- ✅ `user_progress` table
- ✅ `admin_credentials` table
- ✅ Row Level Security (RLS) policies
- ✅ Automatic timestamp triggers
- ✅ Admin view for dashboard

### Step 2: Verify Tables

Run this query to confirm tables were created:

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';
```

You should see:
- user_notes
- user_prompts
- user_progress
- admin_credentials

### Step 3: Configure Supabase (Already Done!)

The following is already configured in the code:

```javascript
SUPABASE_URL: https://xripbgtxettewbsiyhkz.supabase.co
SUPABASE_ANON_KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

No additional configuration needed! 🎉

## 📋 Database Schema

### user_notes
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key to auth.users |
| section_id | VARCHAR(100) | Section identifier |
| note_content | TEXT | User's notes |
| created_at | TIMESTAMPTZ | Creation timestamp |
| updated_at | TIMESTAMPTZ | Last update timestamp |

### user_prompts
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key to auth.users |
| prompt_id | VARCHAR(100) | Prompt identifier |
| custom_prompt | TEXT | Customized prompt |
| created_at | TIMESTAMPTZ | Creation timestamp |
| updated_at | TIMESTAMPTZ | Last update timestamp |

### user_progress
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key to auth.users |
| section_id | VARCHAR(100) | Section identifier |
| completed | BOOLEAN | Completion status |
| time_spent | INTEGER | Time in seconds |
| last_accessed | TIMESTAMPTZ | Last view timestamp |
| created_at | TIMESTAMPTZ | Creation timestamp |

### admin_credentials
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| username | VARCHAR(50) | Admin username |
| password_hash | VARCHAR(255) | Hashed password |
| created_at | TIMESTAMPTZ | Creation timestamp |

## 🚀 Deployment Guide

### Option 1: GitHub Pages (Recommended)

1. **Create GitHub Repository**
   ```bash
   cd /Users/edmundbogen/comet-mastermind-interactive
   git remote add origin https://github.com/edmundbogen/comet-mastermind-interactive.git
   git branch -M main
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to: Settings → Pages
   - Source: Deploy from branch
   - Branch: `main` / `root`
   - Click **Save**

3. **Access Your Site**
   - Your site will be live at: `https://edmundbogen.github.io/comet-mastermind-interactive/`
   - Welcome page: `https://edmundbogen.github.io/comet-mastermind-interactive/welcome.html`

### Option 2: Netlify

1. **Deploy to Netlify**
   - Drag and drop the entire folder to: https://app.netlify.com/drop
   - Or connect your GitHub repo for automatic deployments

2. **Configure**
   - Build command: (leave empty)
   - Publish directory: (leave empty or `.`)

### Option 3: Vercel

1. **Deploy to Vercel**
   ```bash
   npx vercel
   ```

2. **Follow prompts** to deploy

## 📱 Usage Instructions

### For Students

1. **First Time Setup**
   - Visit the welcome page
   - Click "Get Started - It's Free!"
   - Enter your email and create a password
   - You're in! 🎉

2. **Using the Workbook**
   - Navigate through sections using the top menu
   - Click in any "YOUR NOTES" area to start typing
   - Watch for "Saving..." then "Saved ✓" indicators
   - Edit any blue prompt box to customize it
   - Track your progress with the progress bar

3. **Downloading Your Work**
   - Click the green "📥 Download My Workbook" button (bottom right)
   - Opens as HTML file with your name and notes
   - Use browser Print → Save as PDF for PDF version

### For Administrators

1. **Access Dashboard**
   - Navigate to: `your-domain.com/admin-dashboard.html`
   - Enter password: `EdmundBogenAdmin2025!`
   - View all user data and statistics

2. **User Management**
   - Click any user to expand their details
   - See all notes, prompts, and progress
   - Use search to find specific users

3. **Export Data**
   - Click "📥 Export All Data (CSV)"
   - Download includes all user activity
   - Import to Excel/Sheets for analysis

## 🔒 Security Best Practices

### 🚨 IMPORTANT - Change Admin Password

**Before going live, update the admin password:**

1. **In Supabase SQL Editor:**
   ```sql
   UPDATE admin_credentials
   SET password_hash = crypt('YourNewSecurePassword123!', gen_salt('bf'))
   WHERE username = 'admin';
   ```

2. **In admin-dashboard.html (line ~143):**
   ```javascript
   const ADMIN_PASSWORD = 'YourNewSecurePassword123!';
   ```

### Additional Security

- ✅ Row Level Security (RLS) enabled on all tables
- ✅ Users can only access their own data
- ✅ Supabase handles authentication securely
- ✅ HTTPS enforced on GitHub Pages
- ✅ Session-based admin access

## 🎨 Customization

### Update Branding

**Colors** (in all HTML files, look for `:root`):
```css
--primary-blue: #189ad3;  /* BogenHomes blue */
--dark-blue: #0d7aad;
```

**Logo/Hero Image:**
- Replace `mastermind-hero.png` with your image
- Recommended size: 1200x400px

### Modify Content

- Edit `index.html` for workbook content
- Update section IDs if changing structure
- Customize prompts and examples

## 📊 Analytics & Tracking

### Built-in Metrics

The system tracks:
- User registration dates
- Last login times
- Sections viewed
- Time spent per section
- Notes created
- Prompts customized

### Export for Analysis

Export CSV includes:
- User engagement metrics
- Content interaction data
- Progress completion rates
- Custom prompt usage

## 🐛 Troubleshooting

### Notes Not Saving

**Problem:** "Error saving" message appears

**Solutions:**
1. Check Supabase is running: https://status.supabase.com
2. Verify database tables were created (see Setup)
3. Check browser console for errors
4. Ensure user is logged in

### Admin Dashboard Not Loading

**Problem:** User list shows "Loading users..."

**Solutions:**
1. Verify admin password is correct
2. Check Supabase connection
3. Ensure tables have data
4. Check browser console for errors

### Progress Not Updating

**Problem:** Progress bar stuck at 0%

**Solutions:**
1. Scroll through sections to trigger tracking
2. Refresh the page
3. Check `user_progress` table in Supabase
4. Ensure Intersection Observer is supported (modern browsers)

## 🔄 Updates & Maintenance

### Updating Content

1. Edit `index.html`
2. Commit changes: `git add . && git commit -m "Update content"`
3. Push: `git push origin main`
4. GitHub Pages auto-deploys (2-3 min)

### Database Migrations

For schema changes:
1. Create new SQL file: `migration-v2.sql`
2. Run in Supabase SQL Editor
3. Update application code as needed
4. Document changes in README

### Backup Strategy

**Automated:**
- Supabase provides daily backups (Free tier: 7 days)
- GitHub provides version history

**Manual:**
1. Export all data via Admin Dashboard (CSV)
2. Download user data monthly
3. Store in secure location

## 📞 Support

### For Students

**Issues with workbook:**
- Email: edmund@bogenhomes.com
- Subject: "Comet Mastermind - [Issue]"

### For Administrators

**Technical support:**
- Check this README first
- Review Supabase documentation: https://supabase.com/docs
- Contact Edmund for advanced issues

## 📄 File Structure

```
comet-mastermind-interactive/
├── index.html                  # Main workbook
├── login.html                  # Login page
├── register.html               # Registration page
├── welcome.html                # Landing page
├── forgot-password.html        # Password reset
├── admin-dashboard.html        # Admin interface
├── mastermind-hero.png        # Hero image
├── database-setup.sql         # Database schema
├── README.md                  # This file
├── ADMIN-GUIDE.md            # Admin documentation
└── STUDENT-INSTRUCTIONS.md   # Student guide
```

## 🎯 Key Features Summary

| Feature | Description | Status |
|---------|-------------|--------|
| Interactive Notes | Auto-save textareas | ✅ Implemented |
| Editable Prompts | Customizable prompt boxes | ✅ Implemented |
| Progress Tracking | Visual progress bar | ✅ Implemented |
| Time Tracking | Monitor section time | ✅ Implemented |
| Download Workbook | HTML export with notes | ✅ Implemented |
| Admin Dashboard | User management & analytics | ✅ Implemented |
| CSV Export | Data export for analysis | ✅ Implemented |
| Mobile Responsive | Works on all devices | ✅ Implemented |
| Authentication | Secure login/register | ✅ Implemented |
| RLS Security | User data isolation | ✅ Implemented |

## 🚀 Next Steps

1. ✅ Run `database-setup.sql` in Supabase
2. ✅ Change admin password
3. ✅ Push to GitHub
4. ✅ Enable GitHub Pages
5. ✅ Test all features
6. ✅ Share with students!

## 📝 Version History

- **v1.0** (October 2025) - Initial interactive release
  - Auto-save notes and prompts
  - Progress tracking
  - Download feature
  - Admin dashboard
  - Full Supabase integration

## 📜 License

© 2025 Edmund Bogen - BogenHomes
For Real Estate Professionals

---

**Built with ❤️ using:**
- [Supabase](https://supabase.com) - Backend & Database
- [GitHub Pages](https://pages.github.com) - Hosting
- Vanilla JavaScript - No frameworks needed!

**Questions?** Contact Edmund at edmund@bogenhomes.com
