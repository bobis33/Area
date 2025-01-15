# API Documentation

## Overview

This document provides detailed information about the API endpoints available in the backend of the Area project.  
The API is built with [FastAPI](https://fastapi.tiangolo.com/) and uses [Swagger](https://swagger.io/) for live documentation at `http://localhost:8081/docs`.

## Authentication

### POST `/auth/login`

**Description**: Login a user and retrieve an access token.

#### Request Body:
```json
{
  "username": "yourusername",
  "password": "securepassword"
}
```

#### Response:

```json
{
  "access_token": "youraccesstoken"
}
```

### POST `/auth/register`

**Description**: Register a new user.

#### Request Body:
```json
{
  "username": "yourusername",
  "password": "securepassword"
}
```

#### Response:

```json
{
  "message": "User created"
}
```

## Oauth2

### GET `/login/with/google`
