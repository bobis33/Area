from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token

from dao import UserDAO

def login_user(username, password):
    user = UserDAO.find_user_by_username(username)
    if user and check_password_hash(user['password'], password):
        access_token = create_access_token(identity=username)
        return access_token
    return None

def register_user(username, password):
    if UserDAO.find_user_by_username(username):
        return None
    hashed_password = generate_password_hash(password)
    UserDAO.insert_user(username, hashed_password)
    return True
