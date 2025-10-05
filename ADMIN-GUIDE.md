# Admin Guide - Viewing User Data

## How to See Who Has Logged In

1. **Go to Supabase Dashboard:**
   https://supabase.com/dashboard

2. **Select your project:** `comet-mastermind`

3. **Click "Authentication" in the left sidebar**

4. **Click "Users" tab**

You'll see a table with all registered users showing:
- Email address
- Full name (if provided)
- Created at (when they signed up)
- Last sign in (when they last logged in)
- Sign in count (how many times they've logged in)

## Exporting User Data

To download user data as a CSV:

1. Go to **Authentication → Users**
2. Click the **"..."** menu at the top right
3. Select **"Export to CSV"**

## Viewing Login Activity

Supabase automatically tracks:
- **Email confirmations** (if you enable them)
- **Password resets**
- **Login attempts**
- **Last login time**

To see detailed logs:
1. Go to **Logs** in the left sidebar
2. Filter by **"Auth"** to see authentication events

## User Statistics

On the Authentication page, you can see:
- Total users
- Weekly active users (WAU)
- Monthly active users (MAU)

## Managing Users

From the Users tab, you can:
- **Delete users** (click on user → Delete)
- **Reset passwords** (click on user → Send password recovery)
- **View user metadata** (click on user to see full details)
- **Ban users** (temporarily disable access)

## Email Confirmations (Optional)

By default, users can log in immediately after registration.

If you want to require email confirmation:
1. Go to **Authentication → Settings**
2. Scroll to **"Email Confirmations"**
3. Toggle **"Enable email confirmations"**
4. Users will need to click a link in their email before logging in

## Important Notes

- User passwords are **encrypted** - you cannot see them
- All login data is stored securely by Supabase
- Free tier includes unlimited users
- Data is backed up automatically

## Need Help?

- Supabase Documentation: https://supabase.com/docs
- Support: https://supabase.com/support
