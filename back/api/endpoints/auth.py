from flask import Blueprint, make_response, request, jsonify
from flask_jwt_extended import jwt_required

from services import login_user, register_user

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['POST'])
def loginEndpoint():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return make_response(jsonify({'error': 'invalid username or password'}), 400)

    access_token = login_user(username, password)
    if access_token:
        return make_response(jsonify({'token': access_token}), 200)
    else:
        return make_response(jsonify({'error': 'invalid username or password'}), 400)


@auth_bp.route('/register', methods=['POST'])
def registerEndpoint():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return make_response(jsonify({'error': 'invalid username or password'}), 400)

    if register_user(username, password):
        return make_response(jsonify({'message': 'user created'}), 201)
    else:
        return make_response(jsonify({'error': 'username already exists'}), 400)


@auth_bp.route('/protected')
@jwt_required()
def protectedEndpoint():
    return make_response(jsonify({'message': 'protected endpoint'}), 200)
