#!/bin/bash
# health-check.sh — End-to-end health check for Book Review three-tier app
# Usage: ./scripts/health-check.sh

KEY="/home/joy-ukpabi/.ssh/book-review-key"
SSH_OPTS="-i $KEY -o StrictHostKeyChecking=no -o ConnectTimeout=10"

WEB1_IP="18.215.161.201"
WEB2_IP="98.85.222.24"
APP1_IP="10.0.3.24"
APP2_IP="10.0.4.25"
RDS_HOST="rds-jukpabi.cwj4cyce40qi.us-east-1.rds.amazonaws.com"

PASS=0
FAIL=0

check() {
  local label="$1"
  local result="$2"
  if [ "$result" = "ok" ]; then
    echo "  [OK]   $label"
    ((PASS++))
  else
    echo "  [FAIL] $label — $result"
    ((FAIL++))
  fi
}

echo "========================================="
echo " Book Review — Health Check Report"
echo " $(date)"
echo "========================================="

# --- HTTP Endpoint Checks ---
echo ""
echo ">> HTTP Endpoint Checks"

for ip in $WEB1_IP $WEB2_IP; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://$ip/ 2>/dev/null || echo "000")
  if [ "$code" = "200" ] || [ "$code" = "301" ] || [ "$code" = "302" ]; then
    check "HTTP $ip/ → $code" "ok"
  else
    check "HTTP $ip/" "got HTTP $code"
  fi
done

# --- Nginx Status Checks ---
echo ""
echo ">> Nginx Service Status (Web EC2s)"

for ip in $WEB1_IP $WEB2_IP; do
  status=$(ssh -A $SSH_OPTS ubuntu@$ip 'systemctl is-active nginx' 2>/dev/null || echo "unreachable")
  if [ "$status" = "active" ]; then
    check "Nginx on $ip" "ok"
  else
    check "Nginx on $ip" "$status"
  fi
done

# --- PM2 Status Checks ---
echo ""
echo ">> PM2 Service Status (App EC2s)"

# App EC2 #1 via Web EC2 #1
pm2_out=$(ssh -A $SSH_OPTS -o ProxyJump=ubuntu@$WEB1_IP ubuntu@$APP1_IP \
  "pm2 jlist 2>/dev/null | python3 -c \"import sys,json; procs=json.load(sys.stdin); print('online' if all(p['pm2_env']['status']=='online' for p in procs) else 'degraded')\" 2>/dev/null || echo 'unreachable'" 2>/dev/null || echo "unreachable")
check "PM2 on $APP1_IP (via $WEB1_IP)" "$pm2_out"

# App EC2 #2 via Web EC2 #2
pm2_out=$(ssh -A $SSH_OPTS -o ProxyJump=ubuntu@$WEB2_IP ubuntu@$APP2_IP \
  "pm2 jlist 2>/dev/null | python3 -c \"import sys,json; procs=json.load(sys.stdin); print('online' if all(p['pm2_env']['status']=='online' for p in procs) else 'degraded')\" 2>/dev/null || echo 'unreachable'" 2>/dev/null || echo "unreachable")
check "PM2 on $APP2_IP (via $WEB2_IP)" "$pm2_out"

# --- RDS Reachability ---
echo ""
echo ">> RDS Reachability (from App EC2 #1)"

rds_check=$(ssh -A $SSH_OPTS -o ProxyJump=ubuntu@$WEB1_IP ubuntu@$APP1_IP \
  "nc -zw3 $RDS_HOST 3306 2>&1 && echo ok || echo unreachable" 2>/dev/null || echo "ssh_failed")
check "RDS $RDS_HOST:3306" "$rds_check"

# --- ALB Target Group Health (requires AWS CLI) ---
echo ""
echo ">> ALB Target Group Health (AWS CLI)"

if command -v aws &>/dev/null; then
  tg_arns=$(aws elbv2 describe-target-groups \
    --region us-east-1 \
    --query 'TargetGroups[*].TargetGroupArn' \
    --output text 2>/dev/null || echo "")

  if [ -z "$tg_arns" ]; then
    check "ALB Target Groups" "no target groups found or aws CLI error"
  else
    for arn in $tg_arns; do
      tg_name=$(aws elbv2 describe-target-groups \
        --region us-east-1 \
        --target-group-arns "$arn" \
        --query 'TargetGroups[0].TargetGroupName' \
        --output text 2>/dev/null)

      unhealthy=$(aws elbv2 describe-target-health \
        --region us-east-1 \
        --target-group-arn "$arn" \
        --query 'TargetHealthDescriptions[?TargetHealth.State!=`healthy`]' \
        --output text 2>/dev/null)

      if [ -z "$unhealthy" ]; then
        check "ALB TG: $tg_name" "ok"
      else
        check "ALB TG: $tg_name" "unhealthy targets detected"
      fi
    done
  fi
else
  echo "  [SKIP] AWS CLI not found — skipping ALB checks"
fi

# --- Summary ---
echo ""
echo "========================================="
echo " Results: ${PASS} passed, ${FAIL} failed"
echo "========================================="

[ $FAIL -eq 0 ] && exit 0 || exit 1
