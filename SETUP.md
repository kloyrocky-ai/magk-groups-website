# M.A.G.K GROUPS — DEPLOYMENT GUIDE
## From Zero to Live Website in Under 1 Hour

---

## WHAT YOU HAVE

```
magk-site/
├── index.html      → Your public website (with contact form)
├── admin.html      → Your private dashboard (you only)
├── portal.html     → Client login to track projects
├── setup.sql       → Database setup (run once)
└── SETUP.md        → This guide
```

---

## STEP 1 — CREATE YOUR SUPABASE BACKEND (Free)

1. Go to **supabase.com** → Click "Start your project"
2. Sign up with your email
3. Click **"New Project"**
   - Name: `magk-groups`
   - Database password: choose a strong password, SAVE IT
   - Region: choose closest to Rwanda (EU West or similar)
4. Wait 2 minutes for project to be ready

### Get your credentials:
- Go to **Settings → API**
- Copy your **Project URL** (looks like: `https://xxxx.supabase.co`)
- Copy your **anon public key** (long string starting with `eyJ...`)
- SAVE BOTH — you will need them

### Create your database tables:
- Go to **SQL Editor** in Supabase sidebar
- Click **"New Query"**
- Open `setup.sql` from your files
- Copy the entire content and paste it into the SQL editor
- Click **"Run"** (green button)
- You should see: "Success. No rows returned"

### Create your admin account:
- Go to **Authentication → Users**
- Click **"Invite User"** or **"Add User"**
- Enter your email (this is your admin login)
- Set a strong password
- Click Create

---

## STEP 2 — ADD YOUR CREDENTIALS TO THE HTML FILES

Open each of these 3 files and find this section near the top:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

Replace `YOUR_SUPABASE_URL` with your Project URL
Replace `YOUR_SUPABASE_ANON_KEY` with your anon public key

Do this in ALL THREE files:
- index.html
- admin.html  
- portal.html

---

## STEP 3 — PUSH TO GITHUB

1. Go to **github.com** → Sign in or create account
2. Click **"New Repository"**
   - Name: `magk-groups-website`
   - Set to **Public**
   - Click "Create Repository"

3. On your computer, open a terminal/command prompt in your magk-site folder:

```bash
git init
git add .
git commit -m "Initial website"
git remote add origin https://github.com/YOURUSERNAME/magk-groups-website.git
git branch -M main
git push -u origin main
```

Replace `YOURUSERNAME` with your actual GitHub username.

---

## STEP 4 — DEPLOY ON NETLIFY (Free)

1. Go to **netlify.com** → Sign up (use your GitHub account)
2. Click **"Add new site" → "Import an existing project"**
3. Choose **GitHub**
4. Select your `magk-groups-website` repository
5. Leave all settings as default
6. Click **"Deploy site"**

Wait 1-2 minutes. Netlify gives you a live URL like:
`https://random-name-12345.netlify.app`

**Your site is now LIVE.**

---

## STEP 5 — TEST EVERYTHING

1. **Test contact form:** Go to your live URL → Fill form → Submit
   - Check Supabase → Table Editor → enquiries → you should see the submission

2. **Test admin dashboard:** Go to `your-url.netlify.app/admin.html`
   - Login with your admin email and password
   - You should see the submitted enquiry

3. **Test client portal:** Go to `your-url.netlify.app/portal.html`
   - Enter any email → click send link
   - Check that email for login link

---

## STEP 6 — GET A REAL DOMAIN (Optional, ~$15/year)

1. Go to **ricta.org.rw** for `.rw` domain (recommended: `magkgroups.rw`)
2. Or use **namecheap.com** for `.com` ($10-15/year)
3. In Netlify: **Site Settings → Domain management → Add custom domain**
4. Follow Netlify's DNS instructions

---

## HOW TO USE THE ADMIN DASHBOARD

### Every time you get an enquiry:
1. Go to `your-url.netlify.app/admin.html`
2. Login with your email + password
3. Click **Enquiries** in the left sidebar
4. Click **"Manage"** on any enquiry
5. Update status: New → Contacted → Qualified → Converted
6. Add your private notes (client never sees these)

### When you convert a lead to a client:
1. Go to **Clients → Add Client**
2. Enter their name and email
3. Click **"Create Client + Send Portal Invite"**
4. They receive an email with a login link to the portal

### When you create a project for a client:
1. Go to **Projects → New Project**
2. Select the client, fill in project details
3. Click **"Create Project"**
4. The client can now see this in their portal

### Posting project updates (client sees these):
1. Go to **Projects**
2. Find the project → click **"+ Update"**
3. Write the update title, description, and new progress %
4. Click **"Post Update"**
5. Client immediately sees it in their portal

### Recording intelligence notes (only you see these):
1. Go to **Intelligence** in the sidebar
2. Click **"+ Add Note"**
3. Choose category: Deal Flow, Price Intelligence, People, etc.
4. Write what you learned, who told you, what the opportunity is
5. These notes build your market knowledge database over time

---

## MONTHLY MAINTENANCE (5 minutes)

- Log into Supabase → check database is healthy (free tier: 500MB limit)
- Log into Netlify → check site is still live
- Log into admin dashboard → review all enquiries from the month
- Update project progress for all active projects

---

## WHAT EVERYTHING COSTS

| Item | Cost |
|------|------|
| Supabase (backend + database) | FREE up to 50,000 rows |
| Netlify (hosting) | FREE up to 100GB bandwidth |
| GitHub (code repository) | FREE |
| Domain name (.rw) | ~RWF 15,000/year |
| **Total running cost** | **~RWF 15,000/year or $0 without domain** |

---

## IF SOMETHING BREAKS

**Form not submitting:** Check that SUPABASE_URL and SUPABASE_ANON_KEY are correct in index.html

**Admin login not working:** Check that you created a user in Supabase → Authentication → Users

**Client portal not loading projects:** The client's email must match exactly what is in the clients table

**Supabase RLS blocking reads:** Go to Supabase → Authentication → Policies and check that policies were created correctly by the setup.sql

---

## CONTACTS FOR HELP

- Supabase docs: docs.supabase.com
- Netlify docs: docs.netlify.com  
- GitHub docs: docs.github.com

---

*M.A.G.K Groups — Built to scale. Built to last.*
