#!/bin/bash
# FindMyClub one-shot build & run.
# Compiles the Java sources, deploys the webapp into Tomcat, starts Tomcat,
# and opens the app in your default browser.
#
# Usage:  bash run.sh

set -euo pipefail

# --- Locate things --------------------------------------------------------
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOMCAT_HOME="${TOMCAT_HOME:-$HOME/tools/apache-tomcat-9.0.117}"
APP_NAME="findmyclub"
DEPLOY_DIR="$TOMCAT_HOME/webapps/$APP_NAME"

if [ ! -d "$TOMCAT_HOME" ]; then
  echo "❌ Tomcat not found at $TOMCAT_HOME"
  echo "   Set TOMCAT_HOME=/path/to/apache-tomcat-9.0.117 and re-run."
  exit 1
fi

# Pick the Mac's actual JDK (need javac, not just java). Temurin-21 first.
if [ -z "${JAVA_HOME:-}" ]; then
  if [ -x "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/javac" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
  elif command -v /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME="$(/usr/libexec/java_home)"
  fi
fi
JAVAC="${JAVA_HOME:+$JAVA_HOME/bin/}javac"
if ! command -v "$JAVAC" >/dev/null 2>&1; then
  echo "❌ javac not found. Install a JDK (Temurin 21 or similar)."
  exit 1
fi

echo "▶ Project:  $PROJECT_DIR"
echo "▶ Tomcat:   $TOMCAT_HOME"
echo "▶ JDK:      $JAVA_HOME"

# --- Stop Tomcat if running ----------------------------------------------
if curl -fs -o /dev/null "http://localhost:8080/" 2>/dev/null; then
  echo "▶ Stopping running Tomcat..."
  "$TOMCAT_HOME/bin/shutdown.sh" >/dev/null 2>&1 || true
  sleep 2
fi
# Also kill any straggler bound to 8080 just in case.
PIDS="$(lsof -ti :8080 || true)"
if [ -n "$PIDS" ]; then
  echo "▶ Killing leftover process on :8080 ($PIDS)"
  kill -9 $PIDS || true
  sleep 1
fi

# --- Wipe old deploy ------------------------------------------------------
echo "▶ Cleaning old deploy..."
rm -rf "$DEPLOY_DIR" "$DEPLOY_DIR.war"

# --- Build exploded webapp -----------------------------------------------
echo "▶ Building webapp at $DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR/WEB-INF/classes" "$DEPLOY_DIR/WEB-INF/lib"

# Copy webapp resources (JSPs, CSS, etc.) — preserve subdirs, skip src dirs
rsync -a \
  --exclude 'WEB-INF/classes/' \
  "$PROJECT_DIR/src/main/webapp/" "$DEPLOY_DIR/"

# Copy JSTL (already in project's WEB-INF/lib)
cp "$PROJECT_DIR/src/main/webapp/WEB-INF/lib/jstl-1.2.jar" "$DEPLOY_DIR/WEB-INF/lib/"

# --- Compile -------------------------------------------------------------
echo "▶ Compiling Java sources..."
SERVLET_API="$TOMCAT_HOME/lib/servlet-api.jar"
JSP_API="$TOMCAT_HOME/lib/jsp-api.jar"
JSTL="$PROJECT_DIR/src/main/webapp/WEB-INF/lib/jstl-1.2.jar"
CP="$SERVLET_API:$JSP_API:$JSTL"

# Find all .java files and compile to WEB-INF/classes
find "$PROJECT_DIR/src/main/java" -name '*.java' -print0 | \
  xargs -0 "$JAVAC" -source 17 -target 17 \
    -d "$DEPLOY_DIR/WEB-INF/classes" \
    -classpath "$CP"

# --- Start Tomcat --------------------------------------------------------
echo "▶ Starting Tomcat..."
"$TOMCAT_HOME/bin/startup.sh" >/dev/null

# Wait for Tomcat to come up (any HTTP response counts)
URL="http://localhost:8080/$APP_NAME/"
echo -n "▶ Waiting for $URL"
for i in $(seq 1 30); do
  CODE="$(curl -s -o /dev/null -w '%{http_code}' "$URL" 2>/dev/null || echo 000)"
  if [ "$CODE" != "000" ] && [ "$CODE" != "" ]; then
    echo " ✅ (HTTP $CODE)"
    break
  fi
  echo -n "."
  sleep 1
done
echo
echo "▶ Tail of Tomcat log:"
tail -n 5 "$TOMCAT_HOME/logs/catalina.out" 2>/dev/null || true

echo
echo "✅ FindMyClub is running:  $URL"
echo "   (Stop with: $TOMCAT_HOME/bin/shutdown.sh)"

# Open it in the default browser
open "$URL" 2>/dev/null || true
