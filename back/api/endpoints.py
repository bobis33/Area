from flask import make_response, Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required
from flask_pymongo import PyMongo
from werkzeug.security import generate_password_hash, check_password_hash


from config import (
    JWT_SECRET_KEY,
    MONGO_URI
)

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = JWT_SECRET_KEY
app.config["MONGO_URI"] = MONGO_URI
jwt = JWTManager(app)
mongo = PyMongo(app)


@app.route('/')
def hello():
    return make_response(jsonify({'message': 'Supprime ou jte supprime'}), 200)

@app.route('/login', methods=['POST'])
def loginEndpoint():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return make_response(jsonify({'error': 'invalid username or password'}), 400)

    user = mongo.db.users.find_one({"username": username})
    if user and check_password_hash(user['password'], password):
        access_token = create_access_token(identity=username)
        return make_response(jsonify({'token': access_token}), 200)
    else:
        return make_response(jsonify({'error': 'invalid username or password'}), 400)

@app.route('/register', methods=['POST'])
def registerEndpoint():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return make_response(jsonify({'error': 'invalid username or password'}), 400)

    if mongo.db.users.find_one({"username": username}):
        return make_response(jsonify({'error': 'username already exists'}), 400)

    hashed_password = generate_password_hash(password)
    mongo.db.users.insert_one({"username": username, "password": hashed_password})
    return make_response(jsonify({'message': 'user created'}), 201)

@app.route('/protected')
@jwt_required()
def protectedEndpoint():
    return make_response(jsonify({'message': 'protected endpoint'}), 200)
