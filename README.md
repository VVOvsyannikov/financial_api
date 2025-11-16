# 🏦 Simple Financial API

This service provides minimal wallet functionality:  
user creation, balance deposit, money transfers, and balance retrieval.

---

## 🚀 Running the Project with Docker Compose

### Requirements
- Docker
- Docker Compose

### 1. Start the containers

```bash
docker compose up
```

### 2. Create and migrate the database

```bash
docker compose exec app bundle exec rails db:create db:migrate
```

After startup, the API will be available at:

```bash
http://localhost:3000
```

### 3. API documentation

```bash
http://localhost:3000/api_docs
```

### 4. Authorization Header

For deposit, withdraw, transfer, and balance requests, you must send:

```bash
Authorization: Bearer JWT_TOKEN_HERE
```

Example:

```bash
-H "Authorization: Bearer JWT_TOKEN_HERE"
```

### 5. Example CURL Requests

#### 1. Create User

```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"email": "user1@example.com"}'
```

#### 2. Deposit to User

```bash
curl -X POST http://localhost:3000/api/v1/users/deposit \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer JWT_TOKEN_HERE" \
  -d '{"amount": 1000}'
```

#### 3. Check User Balance 

```bash
curl -X GET http://localhost:3000/api/v1/users/balance \
  -H "Authorization: Bearer JWT_TOKEN_HERE"
```

#### 4. Withdraw an amount from a User

```bash
curl -X POST http://localhost:3000/api/v1/users/withdraw \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer JWT_TOKEN_HERE" \
  -d '{"amount": 500}'
```

#### 5. Transfer Money to other User

```bash
curl -X POST http://localhost:3000/api/v1/transfers \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer JWT_TOKEN_HERE" \
  -d '{
        "receiver_email": "user2@example.com",
        "amount": 250
      }'
```