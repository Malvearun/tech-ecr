# Use an official Python Alpine image for a minimal base image
FROM python:3.11-alpine AS base

# Set environment variables for Python to improve performance and logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Install build dependencies for Python packages
RUN apk add --no-cache \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy only requirements.txt first to leverage Docker layer caching
COPY requirements.txt .

# Install Python dependencies (using --no-cache-dir to minimize image size)
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user and group for better security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the rest of the application code
COPY . .

# Ensure the logs directory exists and has correct permissions
RUN mkdir -p /app/logs && \
    touch /app/logs/hello_whale.log && \
    chmod 666 /app/logs/hello_whale.log && \
    chown -R appuser:appgroup /app

# Switch to the non-root user to limit container privileges
USER appuser

# Expose only the necessary port to reduce the attack surface
EXPOSE 8087

# Set up the Datadog log collection configuration using labels
LABEL "com.datadoghq.ad.logs"='[{"type":"file", "path":"/app/logs/hello_whale.log", "service":"hello_whale", "source":"python"}]'

# Define the entry point and command to run the Flask app
ENTRYPOINT ["python"]
CMD ["app.py"]

# Metadata for the Docker image
LABEL maintainer="Your Name <arundilse@gmail.com>" \
      version="1.0" \
      description="Development-ready Flask app with Datadog logging integration"

