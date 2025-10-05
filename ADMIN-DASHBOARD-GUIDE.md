# 📊 Admin Dashboard Guide

Complete guide for administrators to manage the Comet Mastermind Interactive platform.

## 🔐 Access & Login

### Dashboard URL

**Local Development:**
```
http://localhost:8000/admin-dashboard.html
```

**Production (GitHub Pages):**
```
https://edmundbogen.github.io/comet-mastermind-interactive/admin-dashboard.html
```

### Login Credentials

**Default Password:** `EdmundBogenAdmin2025!`

⚠️ **IMPORTANT:** Change this password immediately after setup!

**To Change Password:**

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

3. **Commit and deploy the change**

---

## 📈 Dashboard Overview

### Top Statistics Cards

The dashboard displays 4 key metrics at the top:

1. **Total Users**
   - Count of all registered users
   - Includes active and inactive
   - Auto-updates on page load

2. **Active This Week**
   - Users who logged in within last 7 days
   - Helps track engagement
   - Calculated from `last_sign_in_at`

3. **Total Notes**
   - Count of all notes created across all users
   - Shows content engagement
   - From `user_notes` table

4. **Custom Prompts**
   - Count of customized prompts
   - Shows advanced usage
   - From `user_prompts` table

---

## 👥 User Management

### User List

Each user card shows:

**Header:**
- Full name (or email if no name)
- Email address

**Statistics:**
- **Notes:** Number of notes created
- **Custom Prompts:** Number of prompts customized
- **Sections Viewed:** Number of workbook sections accessed
- **Time Spent:** Total minutes in the workbook
- **Last Login:** Timestamp of last sign-in

### Viewing User Details

**To expand user details:**
1. Click anywhere on the user card
2. Details panel slides down
3. Shows all user activity

**User Details Include:**

#### 📝 User Notes
- Section name
- Full note content
- Last updated timestamp
- Grouped by section

#### ✏️ Custom Prompts
- Prompt identifier
- Customized prompt text
- Last updated timestamp
- Compared to original (future feature)

#### 📊 Section Progress
- List of all sections viewed
- Time spent per section (minutes:seconds)
- Last accessed timestamp
- Completion status (if marked)

---

## 🔍 Search & Filter

### Search Functionality

**Search Input:** Located in the controls bar

**Search by:**
- User email (partial match)
- Full name (partial match)
- Case-insensitive

**How to Search:**
1. Type in search box: "john" or "john@example.com"
2. Click "🔍 Search" button
3. List filters to matching users
4. Clear search to see all users again

**Tips:**
- Search updates on button click, not as you type
- Empty search shows all users
- Uses client-side filtering (fast)

---

## 📥 Data Export

### Export All Data (CSV)

**Button:** Green "📥 Export All Data (CSV)" button

**What's Included:**

**Sheet 1: User Summary**
- User Email
- User Name
- Notes Count
- Prompts Count
- Sections Viewed
- Time Spent (minutes)
- Last Login

**Sheet 2: Detailed Notes**
- User Email
- Section ID
- Note Content
- Updated At timestamp

**Sheet 3: Detailed Prompts**
- User Email
- Prompt ID
- Custom Prompt text
- Updated At timestamp

**How to Export:**
1. Click "📥 Export All Data (CSV)"
2. File downloads automatically
3. Opens in Excel, Google Sheets, etc.

**File Name Format:**
```
comet-mastermind-data-[timestamp].csv
```

**Use Cases:**
- Backup user data
- Analytics and reporting
- Share insights with team
- Compliance documentation

---

## 📊 Analytics & Insights

### Key Metrics to Track

#### Engagement Metrics

**User Activity:**
- Daily/weekly active users
- Average time per user
- Session frequency
- Return rate

**Content Metrics:**
- Most-used sections
- Average notes per user
- Prompt customization rate
- Completion percentage

#### Power Users

**Identify by:**
- High time spent (>60 min)
- Many notes created (>10)
- Custom prompts (>5)
- Regular logins (weekly)

**Action Items:**
- Reach out for testimonials
- Invite to advanced training
- Ask for feedback
- Offer 1-on-1 coaching

#### Inactive Users

**Identify by:**
- No login in 30+ days
- Zero notes created
- <5 minutes total time
- Single section viewed

**Action Items:**
- Send re-engagement email
- Offer help/support
- Provide incentive
- Ask about barriers

---

## 🔔 User Insights

### Understanding User Behavior

#### High Engagement Indicators

✅ **Good Signs:**
- Notes in multiple sections
- Customized prompts
- Regular login pattern
- Increasing time spent
- Progress through sections

#### Low Engagement Indicators

⚠️ **Warning Signs:**
- Single login only
- No notes created
- Quick exit (<2 min)
- Haven't progressed beyond intro
- No return visits

#### Engagement Strategies

**For New Users (0-7 days):**
- Welcome email with quick start guide
- Point to most valuable sections
- Offer live walkthrough

**For Active Users (8-30 days):**
- Check in on progress
- Share advanced tips
- Encourage note-taking

**For Power Users (30+ days):**
- Request feedback
- Invite to community
- Offer advanced content

---

## 🛠️ Admin Tasks

### Daily Tasks (5 min)

- [ ] Check new user registrations
- [ ] Review total active users
- [ ] Scan for any error patterns
- [ ] Quick search for specific users if needed

### Weekly Tasks (15 min)

- [ ] Export data backup (CSV)
- [ ] Analyze engagement trends
- [ ] Identify power users for follow-up
- [ ] Check inactive users list
- [ ] Review top sections

### Monthly Tasks (30 min)

- [ ] Full data export and archive
- [ ] Generate engagement report
- [ ] Plan re-engagement campaigns
- [ ] Review and update content
- [ ] Check database health

### Quarterly Tasks (1 hour)

- [ ] Comprehensive analytics review
- [ ] User satisfaction survey
- [ ] Content effectiveness analysis
- [ ] Database optimization
- [ ] Security audit

---

## 📧 Communication Templates

### Welcome Email (Day 1)

**Subject:** Welcome to Comet Mastermind! Here's how to start

**Body:**
```
Hi [Name],

Welcome to the Comet Mastermind Interactive Workbook! 🎉

I noticed you just registered. Here's how to get the most value:

1. Start with "Getting Started" - takes just 15 minutes
2. Try Use Case #1 for immediate results
3. Take notes in each section (they auto-save!)
4. Customize the prompts for your business

Your progress is tracked automatically, and you can download your completed workbook anytime.

Questions? Just reply to this email.

— Edmund
```

### Re-engagement Email (Day 30)

**Subject:** Haven't seen you in the workbook - everything okay?

**Body:**
```
Hi [Name],

I noticed you haven't logged into the Comet Mastermind workbook recently.

Is everything okay? Did you hit any roadblocks?

I'm here to help! Here are some options:

- 📅 Book a 15-min walkthrough (free)
- 📚 Access the quick start video
- 💬 Reply with your questions

The tools are powerful, but I know getting started can be overwhelming.

What can I help with?

— Edmund
```

### Power User Follow-up

**Subject:** You're crushing it with Comet! Quick favor?

**Body:**
```
Hi [Name],

I noticed you've been actively using the Comet Mastermind workbook:
- [X] notes created
- [X] sections completed
- [X] minutes invested

You're in the top 10% of users! 🌟

Quick favor: Would you share:
1. Your biggest win so far?
2. One thing that surprised you?

I'd love to feature your success story (with permission) to help other agents.

Interested? Just reply!

— Edmund
```

---

## 🔒 Security Best Practices

### Access Control

✅ **Do:**
- Change default password immediately
- Use strong, unique passwords
- Enable 2FA on GitHub/Supabase accounts
- Log out when done
- Use secure connection (HTTPS only)

❌ **Don't:**
- Share admin password
- Access from public computers
- Leave dashboard open unattended
- Use same password elsewhere
- Access over public WiFi (without VPN)

### Data Privacy

✅ **Do:**
- Export data securely
- Store backups encrypted
- Follow GDPR/privacy laws
- Respect user data
- Delete data upon request

❌ **Don't:**
- Share user data publicly
- Export to unsecured locations
- Email sensitive data unencrypted
- Keep unnecessary data
- Access data without purpose

### Incident Response

**If Password Compromised:**
1. Change password immediately
2. Review access logs
3. Check for unauthorized changes
4. Notify users if needed
5. Document incident

**If Data Breach:**
1. Secure the system
2. Assess scope of breach
3. Notify affected users
4. Report to authorities (if required)
5. Review security measures

---

## 🐛 Troubleshooting

### Dashboard Not Loading

**Symptom:** Stuck on "Loading users..."

**Solutions:**
1. Check internet connection
2. Verify Supabase is online: https://status.supabase.com
3. Check browser console for errors (F12)
4. Clear browser cache
5. Try incognito/private mode

**Still not working?**
- Check database tables exist
- Verify RLS policies are set
- Ensure data exists

### Wrong Password

**Symptom:** "Invalid password" message

**Solutions:**
1. Double-check password (case-sensitive)
2. Verify no extra spaces
3. Check Caps Lock is off
4. Reset password in Supabase:
   ```sql
   SELECT * FROM admin_credentials;
   -- Verify password_hash exists

   UPDATE admin_credentials
   SET password_hash = crypt('NewPassword123!', gen_salt('bf'))
   WHERE username = 'admin';
   ```

### Export Not Working

**Symptom:** No CSV downloads

**Solutions:**
1. Check browser download settings
2. Disable popup blocker
3. Try different browser
4. Check browser console for errors
5. Verify data exists in database

### User Data Missing

**Symptom:** User shows zero notes/prompts but should have data

**Solutions:**
1. Check in Supabase directly:
   ```sql
   SELECT * FROM user_notes WHERE user_id = 'user-uuid';
   ```
2. Verify RLS policies allow access
3. Check for database errors
4. Refresh dashboard
5. Re-run data load function

---

## 📱 Mobile Access

### Responsive Design

The admin dashboard works on mobile devices:

**Optimized for:**
- ✅ Tablets (iPad, Android tablets)
- ⚠️ Smartphones (limited functionality)
- ✅ Desktop (best experience)

**Mobile Tips:**
- Use landscape mode
- Tap user cards to expand
- Swipe to scroll
- Export on desktop for best results

---

## 🔄 Updates & Maintenance

### Keeping Dashboard Updated

**Check for Updates:**
1. Visit GitHub repo
2. Check for new releases
3. Review changelog
4. Pull latest changes

**To Update:**
```bash
cd /Users/edmundbogen/comet-mastermind-interactive
git pull origin main
```

**GitHub Pages Auto-deploys:**
- Changes pushed to `main` branch
- Auto-deploy in 2-3 minutes
- No manual steps needed

---

## 📞 Support

### Getting Help

**Technical Issues:**
- Check this guide first
- Review DATABASE-SCHEMA.md
- Check Supabase docs: https://supabase.com/docs
- Review browser console errors

**Contact:**
- Email: edmund@bogenhomes.com
- Subject: "Admin Dashboard - [Issue]"

**Include in Support Request:**
- Description of issue
- Steps to reproduce
- Browser and version
- Screenshots if applicable
- Error messages (from console)

---

## 📋 Quick Reference

### Common Tasks

| Task | Steps |
|------|-------|
| View User Details | Click user card |
| Search Users | Type name/email → Click Search |
| Export Data | Click green Export button |
| Refresh Data | Reload page (⌘+R / Ctrl+R) |
| Logout | Click Logout button (top right) |

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| F5 | Refresh dashboard |
| Ctrl/⌘ + F | Search users (browser find) |
| Esc | Close user details (future) |
| Ctrl/⌘ + R | Reload page |

### Important URLs

| Resource | URL |
|----------|-----|
| Admin Dashboard | `/admin-dashboard.html` |
| Supabase Dashboard | https://app.supabase.com |
| GitHub Repo | https://github.com/edmundbogen/comet-mastermind-interactive |
| Live Site | https://edmundbogen.github.io/comet-mastermind-interactive/ |

---

## 🎯 Success Metrics

### Track These KPIs

**User Growth:**
- New registrations per week
- Active user percentage
- Retention rate (30/60/90 day)

**Engagement:**
- Average time per user
- Notes per user
- Sections completed
- Return visit frequency

**Content:**
- Most popular sections
- Drop-off points
- Completion rates
- Prompt customization

**Business Impact:**
- User testimonials
- Success stories
- ROI for students
- Referrals generated

---

**Last Updated:** October 2025
**Dashboard Version:** 1.0

For additional support, contact Edmund at edmund@bogenhomes.com
