from flask import Flask, request, jsonify
from revChatGPT.Unofficial import Chatbot
import json
from flask_cors import CORS
from flask_ngrok import run_with_ngrok

# Load API token from config file
with open("./config.json") as f:
    token = json.load(f)

# Create a Chatbot instance
api = Chatbot(token)

app = Flask(__name__)
run_with_ngrok(app)

@app.route('/')
def hello():
    return "Hello, World!"

@app.route('/api', methods=['GET'])
def ask():
    # Get the query (prompt) from the query parameter
    query = request.args.get('Query')

    if query:
        # Get response from the Chatbot
        response = api.ask(query)
        print(response['message'])

        # Return the response as JSON
        return jsonify({'response': response['message']})
    else:
        return jsonify({'response': 'Query parameter is missing'}), 400

if __name__ == '__main__':
    app.run(port=8080)