# Backend

## Description

This is the backend for the area project. It is build with [Python](https://www.python.org/), [FastAPI](https://fastapi.tiangolo.com/) and [mongoDB](https://www.mongodb.com/).

## Run

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

