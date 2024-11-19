from flask import make_response, Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'default'
jwt = JWTManager(app)

@app.route('/')
def hello():
    return make_response("Supprime ou jte supprime", 200)




# User managment
userDatabase = [
  {'id': 1, 'username': 'Alice', 'password': 'password'},
  {'id': 2, 'username': 'Bob', 'password': 'password'},
  {'id': 3, 'username': 'Charlie', 'password': 'password'},
]


@app.route('/login', methods=['POST'])
def loginEndpoint():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return make_response('invalid username or password', 400)

    try:
        user = next(user for user in userDatabase if user['username'] == username)
        if user['password'] != password:
            return make_response('Invalid password', 401)

        access_token = create_access_token(identity=username)
        return make_response(jsonify({'token': access_token}), 200)

    except ConnectionError:
        return make_response('User not found', 404)


@app.route('/register', methods=['POST'])
def registerEndpoint():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return make_response('invalid username or password', 400)

    if next((user for user in userDatabase if user['username'] == username), None):
        return make_response('User already exists', 400)

    userDatabase.append({'id': len(userDatabase) + 1, 'username': username, 'password': password})
    return make_response('User created', 201)


@app.route('/protected')
@jwt_required()
def protectedEndpoint():
    return make_response('You are authorized', 200)
