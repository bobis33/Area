# Use an official Python runtime as a parent image
FROM python:3.13

# Set the working directory
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .

RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Define the command to run the app
CMD ["python", "run.py"]
