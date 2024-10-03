import os
from flask import Flask, request, render_template
import logging
from datadog import initialize, statsd

# Initialize the Flask application
app = Flask(__name__)

# Initialize Datadog with API key and App key from environment variables
options = {
    'api_key': os.getenv('DD_API_KEY'),
    'app_key': os.getenv('DD_APP_KEY')
}
initialize(**options)

# Define the log format
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Setup Datadog logging handler
class DatadogHandler(logging.Handler):
    def emit(self, record):
        log_entry = self.format(record)
        statsd.increment('flask_app.logs', tags=[f"level:{record.levelname.lower()}", f"message:{log_entry}"])

datadog_handler = DatadogHandler()
datadog_handler.setLevel(logging.DEBUG)
datadog_handler.setFormatter(formatter)
app.logger.addHandler(datadog_handler)

# File handler for logging to a file
file_handler = logging.FileHandler('/app/logs/hello_whale.log')  # Update path here
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)
app.logger.addHandler(file_handler)

# Console handler for logging to the console
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
console_handler.setFormatter(formatter)
app.logger.addHandler(console_handler)

# Ensure Flask logs are at DEBUG level
app.logger.setLevel(logging.DEBUG)

@app.route('/')
def hello_whale():
    app.logger.info("Info log: Accessed the hello_whale route.")  # Info log
    app.logger.debug("Debug log: This is a debug message from hello_whale.")  # Debug log
    return 'Whale, Hello there!'

@app.route('/log_example', methods=['GET', 'POST'])
def log_example():
    if request.method == 'POST':
        message = request.form.get('message', '')
        app.logger.info(f"Received message: {message}")  # Info log
        app.logger.warning("Warning log: Message processing may have issues.")  # Warning log
        return render_template('index.html', result=f"Message received: {message}")
    
    app.logger.info("Info log: GET request made to the log_example route.")
    return render_template('index.html', result=None)

@app.route('/critical', methods=['GET'])
def critical():
    app.logger.critical("Critical log: This is a critical log entry.")  # Critical log
    return "Critical log entry created!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8087, debug=True)  # Update port here if needed
