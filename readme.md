# LocalStack & Fluent Bit Setup Guide

## Run LocalStack Container

LocalStack is a fully functional local AWS cloud stack. Follow the steps below to set up and run LocalStack:

### 1. Pull LocalStack Docker Image
```sh
docker pull localstack/localstack
```

### 2. Run LocalStack Container
```sh
docker run -d \
 -p 4566:4566 \
 -p 4571:4571 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 localstack/localstack
```

### 3. Configure AWS CLI for LocalStack
```sh
aws configure --profile localstack
```
Use the following credentials when prompted:
- **AWS Access Key ID**: `test`
- **AWS Secret Access Key**: `test`
- **Default region**: `us-east-1`
- **Default output format**: `json`

### 4. Set AWS Credentials as Environment Variables
```sh
export AWS_PROFILE=localstack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
```

### 5. Manage LocalStack Container
#### Find LocalStack Container
```sh
docker ps | grep localstack
```
#### Stop the Container
```sh
docker stop <CONTAINER_ID>
```
#### Remove LocalStack Container
```sh
docker rm <CONTAINER_ID>
```
#### Remove LocalStack Image
```sh
docker rmi localstack/localstack
```

---

## Setup Fluent Bit

Fluent Bit is a lightweight and high-performance log processor and forwarder. Follow the steps below to set it up:

### 1. Install Fluent Bit
```sh
brew install fluent-bit
```

### 2. Create or Update CloudWatch Log Groups
```sh
chmod +x setup-cloudwatch.sh
./setup-cloudwatch.sh
```

### 3. Run Fluent Bit
Ensure AWS credentials are set before running Fluent Bit.
```sh
fluent-bit -c ./fluent-bit.conf
```

### 4. Run Setup and Fluent Bit in a Single Command
```sh
./setup-cloudwatch.sh && fluent-bit -c ./fluent-bit.conf
```

---

## Read Log Groups and Streams

### List All Log Groups
```sh
aws --endpoint-url=http://localhost:4566 logs describe-log-groups
```

### List Audit Log Streams
```sh
aws --endpoint-url=http://localhost:4566 logs describe-log-streams --log-group-name audit_logs
```

### List App Log Streams (Includes Audit Logs)
```sh
aws --endpoint-url=http://localhost:4566 logs describe-log-streams --log-group-name app_logs
```

### Retrieve Audit Log Events
```sh
aws --endpoint-url=http://localhost:4566 logs get-log-events \
 --log-group-name audit_logs \
 --log-stream-name audit_logs_stream
```

### Retrieve App Log Events (Includes Audit Logs)
```sh
aws --endpoint-url=http://localhost:4566 logs get-log-events \
 --log-group-name app_logs \
 --log-stream-name app_logs_stream
```

---

## Add Data to Log Files

### Create Input File with Log Data
```sh
echo '{ "name": "ABC", "log_type": "AUDIT" }' > input.txt
```

### Append Data to the Log File
```sh
echo '{ "name": "DEF", "log_type": "APP" }' >> input.txt
```
### Notes:
- Ensure you have **AWS CLI**, **Docker**, and **Fluent Bit** installed.
- Adjust the configuration files (`fluent-bit.conf`, `setup-cloudwatch.sh`) as needed.
- Replace `<CONTAINER_ID>` with the actual container ID when managing LocalStack.
- Replace `audit_logs_stream` and `app_logs_stream` with actual stream names if different.

