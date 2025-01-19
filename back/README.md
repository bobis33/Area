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

### Environment Variables

The application uses several environment variables for configuration. Below are the key variables:

```dotenv
GOOGLE_CLIENT_ID=<your-google-client-id>
GOOGLE_CLIENT_SECRET=<your-google-client-secret>
GITHUB_CLIENT_ID=<your-github-client-id>
GITHUB_CLIENT_SECRET=<your-github-client-secret>
DISCORD_CLIENT_ID=<your-discord-client-id>
DISCORD_CLIENT_SECRET=<your-discord-client-secret>
SPOTIFY_CLIENT_ID=<your-spotify-client-id>
SPOTIFY_CLIENT_SECRET=<your-spotify-client-secret>
GITLAB_CLIENT_ID=<your-gitlab-client-id>
GITLAB_CLIENT_SECRET=<your-gitlab-client-secret>
FRONTEND_URL=http://localhost:8081
MOBILE_URL=myapp://oauth
```

---


## API Endpoints

### Authentication

- `POST /login`: User login.
- `POST /register`: User registration.
- `GET /me`: Check if the user is logged in.

### Service Linking Status

- `GET /is/linked/google`: Check if Google is linked.
- `GET /is/linked/discord`: Check if Discord is linked.
- `GET /is/linked/spotify`: Check if Spotify is linked.
- `GET /is/linked/github`: Check if GitHub is linked.
- `GET /is/linked/gitlab`: Check if GitLab is linked.

### OAuth Integration

- **Google**:
  - `GET /login/with/google`: OAuth login.
  - `POST /link/google`: Link Google account.
- **Discord**:
  - `GET /login/with/discord`: OAuth login.
  - `POST /link/discord`: Link Discord account.
- **Spotify**:
  - `GET /login/with/spotify`: OAuth login.
  - `POST /link/spotify`: Link Spotify account.
- **GitHub**:
  - `GET /login/to/github`: OAuth login.
  - `POST /link/github`: Link GitHub account.
- **GitLab**:
  - `GET /login/to/gitlab`: OAuth login.
  - `POST /link/gitlab`: Link GitLab account.

### Example Response

For a successful OAuth link, the API returns:
```json
{
  "message": "<Service> account linked successfully"
}
```

---

## Supported Services

| Service  | Actions                             | Reactions                            |
|----------|-------------------------------------|---------------------------------------|
| Gmail    | `Mail Received`                    | `Send Mail`                          |
| Discord  | None                               | `Add Role`, `Kick User`, `Send DM`   |
| GitHub   | `New Issue`, `Repo Created`        | `Create Repo`                        |
| Spotify  | `New Liked Track`                  | `Add to Playlist`, `Play Song`       |
| GitLab   | `New Issue`, `Repo Created`        | None                                 |

---

## About

- **Server Details**:
  - Host: `127.0.0.1:8080`
  - Current Version: `0.0.0+1`

- **Client Details**:
  - Host: `172.18.0.1`

### Example Configuration

- **GMail**: Triggers when new mail is received or sends emails.
- **Spotify**: Adds a song to your playlist or plays a track.
- **GitHub**: Tracks issue assignments and repository updates.

---

## External ressources:
- **SPOTIFY**:
  - How to get device uri: https://developer.spotify.com/documentation/web-api/reference/get-a-users-available-devices
