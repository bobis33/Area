# Backend

## Description

This is the backend for the area project. It is build with [Python](https://www.python.org/), [FastAPI](https://fastapi.tiangolo.com/) and [mongoDB](https://www.mongodb.com/).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)

You will have to create a `.env` file in the `app/` folder and copy the content of the `.env.example` file in it. You will have to fill the variables with your own values.
In production, you will have to change the `FRONTEND_URL` variable to the url of the frontend.

## Usage

It is recommended to use [docker-compose](https://docs.docker.com/compose/) to run the backend. You can start the backend on `http://localhost:8081` with the following command at the root of the main project:

```bash
docker-compose up server
```

Alternatively, you can run the backend without docker-compose. Make sure to install the dependencies:

```bash
pip install -r requirements.txt
```

Then you can start the server on `http://localhost:8081`:

```bash
./run.py
```

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
