#!/bin/bash
# post-deploy.sh — Restart PM2 on App EC2s and reload Nginx on Web EC2s
# Usage: ./scripts/post-deploy.sh

set -euo pipefail

KEY="/home/joy-ukpabi/.ssh/book-review-key"
SSH_OPTS="-i $KEY -o StrictHostKeyChecking=no -o ConnectTimeout=10"

WEB1="ec2-user@18.215.161.201"
WEB2="ec2-user@98.85.222.24"
APP1="ec2-user@10.0.3.24"
APP2="ec2-user@10.0.4.25"

echo "=============================="
echo " Book Review — Post-Deploy"
echo "=============================="

# --- App EC2 #1: Restart PM2 ---
echo ""
echo "[1/4] Restarting PM2 on App EC2 #1 (10.0.3.24)..."
ssh $SSH_OPTS -o ProxyJump=$WEB1 $APP1 '
  pm2 restart all
  pm2 status
' && echo "  PM2 restart OK on App EC2 #1" || echo "  ERROR: PM2 restart FAILED on App EC2 #1"

# --- App EC2 #2: Restart PM2 ---
echo ""
echo "[2/4] Restarting PM2 on App EC2 #2 (10.0.4.25)..."
ssh $SSH_OPTS -o ProxyJump=$WEB2 $APP2 '
  pm2 restart all
  pm2 status
' && echo "  PM2 restart OK on App EC2 #2" || echo "  ERROR: PM2 restart FAILED on App EC2 #2"

# --- Web EC2 #1: Reload Nginx ---
echo ""
echo "[3/4] Reloading Nginx on Web EC2 #1 (18.215.161.201)..."
ssh $SSH_OPTS $WEB1 '
  sudo nginx -t && sudo systemctl reload nginx
  sudo systemctl status nginx --no-pager | grep "Active:"
' && echo "  Nginx reload OK on Web EC2 #1" || echo "  ERROR: Nginx reload FAILED on Web EC2 #1"

# --- Web EC2 #2: Reload Nginx ---
echo ""
echo "[4/4] Reloading Nginx on Web EC2 #2 (98.85.222.24)..."
ssh $SSH_OPTS $WEB2 '
  sudo nginx -t && sudo systemctl reload nginx
  sudo systemctl status nginx --no-pager | grep "Active:"
' && echo "  Nginx reload OK on Web EC2 #2" || echo "  ERROR: Nginx reload FAILED on Web EC2 #2"

echo ""
echo "=============================="
echo " Post-deploy complete."
echo "=============================="
