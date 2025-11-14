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
docker compose up --build
```

### 2. Create and migrate the database

```bash
docker compose exec app bundle exec rails db:create db:migrate
```

After startup, the API will be available at:

```bash
http://localhost:3000
```

### 3. Authorization Header

For deposit, withdraw, transfer, and balance requests, you must send:

```bash
Authorization: Bearer JWT_TOKEN_HERE
```

Example:

```bash
-H "Authorization: Bearer JWT_TOKEN_HERE"
```

### 4. Example CURL Requests

#### 1. Create User #1

```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"email": "user1@example.com"}'
```

Sample Response:

```json
{
  "user": {
    "id": 1,
    "email": "user1@example.com",
    "balance": "0.0"
  },
  "token": "JWT_TOKEN_HERE"
}
```

#### 2. Create User #2

```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"email": "user2@example.com"}'
```

#### 3. Deposit to User #1

```bash
curl -X POST http://localhost:3000/api/v1/users/1/deposit \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer JWT_TOKEN_HERE" \
  -d '{"amount": 1000}'
```
Sample Response:

```json
{
  "user": {
    "id": 1,
    "balance": "1000.0"
  }
}
```
#### 4. Transfer Money from User #1 → User #2

```bash
curl -X POST http://localhost:3000/api/v1/transfers \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer JWT_TOKEN_HERE" \
  -d '{
        "receiver_id": 2,
        "amount": 250
      }'
```
Sample Response:

```json
{
  "sender_balance":"750.0",
  "receiver_balance":"250.0"
}
```

#### 5. Check Balance of User #2

```bash
curl -X GET http://localhost:3000/api/v1/users/2/balance \
  -H "Authorization: Bearer JWT_TOKEN_HERE"
```
Sample Response:

```json
{
  "user":{
    "id":2,
    "balance":"250.0"
  }
}
```