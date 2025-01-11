# Backend

## Description

This is the backend for the area project. It is build with [Python](https://www.python.org/), [FastAPI](https://fastapi.tiangolo.com/) and [mongoDB](https://www.mongodb.com/).

## Run

First create a .env file in the app/ folder and copy the content of the .env.example file in it. You will have to fill the variables with your own values.
In production, you will have to change the FRONTEND_URL variable to the url of the frontend.


It is recommended to use [docker-compose](https://docs.docker.com/compose/) to run the backend. You can start the backend with the following command at the root of the main project:

```bash
docker-compose up server
```

Alternatively, you can run the backend without docker-compose. Make sure to install the dependencies:

```bash
pip install -r requirements.txt
```

Then you can start the backend with:

```bash
./run.py
```

