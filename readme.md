<!-- Run LocalStack container -->
========================================================================================================================
docker pull localstack/localstack

docker run -d \
 -p 4566:4566 \
 -p 4571:4571 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 localstack/localstack

# Configure AWS CLI to use LocalStack
aws configure --profile localstack

# When prompted, use:
# AWS Access Key ID: test
# AWS Secret Access Key: test
# Default region: us-east-1
# Default output format: json
# Set environment variables

# Set AWS credentials
export AWS_PROFILE=localstack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

<!-- EXtra Information if needed -->
# Find LocalStack container
docker ps | grep localstack

# Stop the container
docker stop <CONTAINER_ID>

# Remove LocalStack container
docker rm <CONTAINER_ID>

# Remove LocalStack image
docker rmi localstack/localstack
========================================================================================================================

# <!-- Setup Fluentbit -->
========================================================================================================================
brew install fluent-bit

# Delete if exisitng and then create Log groups using script 
chmod +x setup-cloudwatch.sh
./setup-cloudwatch.sh

# AWS Creds must be set then we can run fluent bit

fluent-bit -c ./fluent-bit.conf

# can run using single command
./setup-cloudwatch.sh && fluent-bit -c ./fluent-bit.conf
========================================================================================================================

<!-- READ LOG GROUPS AND STREAMS -->
========================================================================================================================
# List All
aws --endpoint-url=http://localhost:4566 logs describe-log-groups

# List Audit Log Streams
aws --endpoint-url=http://localhost:4566 logs describe-log-streams --log-group-name audit_logs

# List App Log Streams(Includes AUDIT)
aws --endpoint-url=http://localhost:4566 logs describe-log-streams --log-group-name app_logs


# Retrieve Audit Log Events
aws --endpoint-url=http://localhost:4566 logs get-log-events \
 --log-group-name audit_logs \
 --log-stream-name audit_logs_stream

# Retrieve App Log Events (Includes AUDIT)
aws --endpoint-url=http://localhost:4566 logs get-log-events \
 --log-group-name app_logs \
 --log-stream-name app_logs_stream
========================================================================================================================

========================================================================================================================
# Add data
echo '{ "name": "ABC", "log_type": "AUDIT" }' > input.txt

# Append data
echo '{ "name": "DEF", "log_type": "APP" }' >> input.txt
========================================================================================================================
