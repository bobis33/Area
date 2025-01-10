FROM python:3.8 AS build

COPY requirements.txt .

RUN pip install --user -r requirements.txt

FROM python:3.8-slim AS production

WORKDIR /app

COPY --from=build /root/.local /root/.local
COPY . .

EXPOSE 8081

CMD ["python", "run.py"]
