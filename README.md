# Smart Tiffin — Universal Flutter Monorepo

> One repository containing all three Flutter applications with GitHub Actions synchronization.

## 📦 Repository Structure

```
smart-tiffin/
├── .github/workflows/
│   ├── sync-from-sources.yml      # Pull updates from source repos
│   ├── switch-active-app.yml      # Switch FlutterLab active app
│   └── push-back-to-source.yml    # Push changes back to source repo via PR
│
├── apps/
│   ├── customer/    ← Full source from github.com/.../alu
│   ├── admin/       ← Full source from github.com/.../alu-admin
│   └── partner/     ← Full source from github.com/.../alu-partner
│
├── packages/        ← Shared packages (active app's packages at root)
├── lib/             ← Active app entry point
├── android/         ← Active app Android config
├── ios/             ← Active app iOS config
├── web/             ← Active app web config
├── pubspec.yaml     ← Active app dependencies
└── ACTIVE_APP       ← Which app is currently active at root
```

## 🚀 FlutterLab Usage

**Import this repo into FlutterLab:**
```
https://github.com/rabbyjahidulislam5-art/smart-tiffin.git
```
Branch: `main`

**Currently Active App:** See `ACTIVE_APP` file at root.

## 🔄 Switch Active App (GitHub Actions)

Go to **Actions → Switch Active App → Run workflow** → Select app:
- `customer` → Customer App (default)
- `admin` → Admin & Accounting App
- `partner` → Partner (Supplier & Rider) App

After switching, re-import in FlutterLab to get the new app.

## 📥 Sync From Source Repos

**Automatic:** Runs every 6 hours via cron.

**Manual:** Go to **Actions → Sync From Source Repos → Run workflow**
- Select `all` to sync all three apps
- Or select specific app

## 📤 Push Changes Back to Source

After editing code in this repo:

1. Go to **Actions → Push Changes Back to Source Repo → Run workflow**
2. Select which app was changed
3. A new branch will be pushed to the source repo
4. Open a PR manually to review and merge

## 🔐 Required Secret

Add this secret in repo **Settings → Secrets → Actions**:
- Name: `SYNC_TOKEN`
- Value: Your GitHub Classic Token (with `repo` scope)

## 📱 Source Repositories

| App | Source Repo |
|-----|-------------|
| Customer | https://github.com/rabbyjahidulislam5-art/alu |
| Admin & Accounting | https://github.com/rabbyjahidulislam5-art/alu-admin |
| Partner | https://github.com/rabbyjahidulislam5-art/alu-partner |
