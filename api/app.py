# my_api_project/app.py
from flask import Flask, jsonify
from users import users_bp  # Import the users Blueprint

app = Flask(__name__)

# Register the Blueprint
app.register_blueprint(users_bp)  # Register the Blueprint

@app.route('/')
def home():
    return jsonify({'message': 'Welcome to the API!'})


if __name__ == '__main__':
    app.run(debug=True)