from flask import Flask
from aws_lambda_powertools import Logger

app = Flask(__name__)
logger = Logger()

@app.route('/')
def hello_whale():
    return "Whale, Hello there!"

def lambda_handler(event, context):
    from aws_lambda_wsgi import response
    return response(app, event, context)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8089)
    
