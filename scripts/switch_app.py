#!/usr/bin/env python3
"""
Smart Tiffin — Local App Switcher Script
Usage: python scripts/switch_app.py [customer|admin|partner]
"""

import os, sys, shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
APPS_DIR = os.path.join(ROOT, "apps")
ACTIVE_FILE = os.path.join(ROOT, "ACTIVE_APP")
SWITCH_DIRS = ["lib", "android", "ios", "web", "test", "packages"]
SWITCH_FILES = ["pubspec.yaml", "pubspec.lock", "analysis_options.yaml", ".metadata"]

VALID_APPS = ["customer", "admin", "partner"]

def read_active():
    if os.path.exists(ACTIVE_FILE):
        return open(ACTIVE_FILE).read().strip()
    return "none"

def switch(app):
    if app not in VALID_APPS:
        print(f"❌ Invalid app '{app}'. Choose: {VALID_APPS}")
        sys.exit(1)

    current = read_active()
    if current == app:
        print(f"✅ '{app}' is already active.")
        return

    print(f"🔄 Switching from '{current}' → '{app}'...")
    src = os.path.join(APPS_DIR, app)

    # Remove current root Flutter dirs/files
    for d in SWITCH_DIRS:
        path = os.path.join(ROOT, d)
        if os.path.exists(path):
            shutil.rmtree(path)
    for f in SWITCH_FILES:
        path = os.path.join(ROOT, f)
        if os.path.exists(path):
            os.remove(path)

    # Copy selected app to root
    for d in SWITCH_DIRS:
        s = os.path.join(src, d)
        if os.path.exists(s):
            shutil.copytree(s, os.path.join(ROOT, d))

    for f in SWITCH_FILES:
        s = os.path.join(src, f)
        if os.path.exists(s):
            shutil.copy2(s, os.path.join(ROOT, f))

    # Update ACTIVE_APP
    open(ACTIVE_FILE, "w").write(app)

    print(f"✅ Active app is now: {app}")
    print(f"   Run: flutter pub get && flutter run")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Current active app: {read_active()}")
        print(f"Usage: python switch_app.py [customer|admin|partner]")
    else:
        switch(sys.argv[1].lower())
