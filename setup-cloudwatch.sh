echo "Clear input file content"
> input.txt

echo "Clearing existing logs and creating new log groups"

echo "=============== DELETION LOGIC IF EXISITING ====================================================================="
# Delete audit logs group if it exists
aws --endpoint-url=http://localhost:4566 logs delete-log-group \
    --log-group-name audit_logs 2>/dev/null || true

# Delete app logs group if it exists
aws --endpoint-url=http://localhost:4566 logs delete-log-group \
    --log-group-name app_logs 2>/dev/null || true

# Verify no log groups exist
echo "Verifying log groups Deletion..."
aws --endpoint-url=http://localhost:4566 logs describe-log-groups
echo "Log groups deleted (if they existed)"

echo "=============== CREATE LOG GROUPS LOGIC ====================================================================="

aws --endpoint-url=http://localhost:4566 logs create-log-group --log-group-name audit_logs
aws --endpoint-url=http://localhost:4566 logs create-log-group --log-group-name app_logs

# Verify log groups created
echo "Verifying log groups creation..."
aws --endpoint-url=http://localhost:4566 logs describe-log-groups

# aws --endpoint-url=http://localhost:4566 logs create-log-stream \
#     --log-group-name audit_logs \
#     --log-stream-name audit_logs_stream

# aws --endpoint-url=http://localhost:4566 logs create-log-stream \
#     --log-group-name app_logs \
#     --log-stream-name app_logs_stream

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1