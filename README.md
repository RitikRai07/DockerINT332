# Node.js + MongoDB Docker Compose Setup

This is a complete Docker Compose setup for a Node.js application connected to MongoDB.

## Services

- **nodejs_app**: Node.js Express server running on port 3000
- **mongodb_container**: MongoDB database on port 27017

## Prerequisites

- Docker
- Docker Compose

## Environment Variables

The application uses the following environment variables:
- `MONGO_URI`: MongoDB connection string (default: mongodb://mongo:27017/nodedb)
- `NODE_ENV`: Environment mode (default: development)

MongoDB credentials:
- Username: `admin`
- Password: `password`
- Database: `nodedb`

## Getting Started

1. Navigate to the Exam-P2 directory:
```bash
cd Exam-P2
```

2. Start the services:
```bash
docker-compose up -d
```

3. Check the status:
```bash
docker-compose ps
```

4. View logs:
```bash
docker-compose logs -f app
```

## API Endpoints

- `GET /` - Home endpoint
- `GET /health` - Health check
- `GET /api/users` - Get all users
- `POST /api/users` - Create a new user
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

## Example API Calls

### Get all users
```bash
curl http://localhost:3000/api/users
```

### Create a new user
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

### Health check
```bash
curl http://localhost:3000/health
```

## Stopping the Services

```bash
docker-compose down
```

To also remove the volumes:
```bash
docker-compose down -v
```

## Viewing Database

You can connect to MongoDB using MongoDB Compass or mongo CLI:
```bash
mongodb://admin:password@localhost:27017/nodedb
```

## Project Structure

```
Exam-P2/
├── docker-compose.yml
├── app/
│   ├── app.js
│   └── package.json
└── README.md
```

## Features

- Express.js server with REST API
- MongoDB with authentication
- Automatic database volume persistence
- Graceful shutdown handling
- Health check endpoint
- User CRUD operations
