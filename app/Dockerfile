# Use an official Python runtime as a parent image
FROM python:3.11-slim-buster AS base

# Environment variables to improve pip performance and behavior
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Install dependencies required for building Python packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file and install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Install AWS Lambda Powertools and AWS Lambda Runtime Interface Client
RUN pip install aws-lambda-powertools awslambdaric

# Add a non-root user for security purposes
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy the application code
COPY . .

# Set the user to non-root for running the application
USER appuser

# Expose the application port
EXPOSE 8089

# Set the CMD to run the Flask application directly
CMD ["flask", "run", "--host=0.0.0.0", "--port=8089"]

