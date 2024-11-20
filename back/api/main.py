from flask import Flask
from flask_jwt_extended import JWTManager

from endpoints.auth import auth_bp
from extensions import mongo
from config import JWT_SECRET_KEY, MONGO_URI

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = JWT_SECRET_KEY
app.config["MONGO_URI"] = MONGO_URI
app.register_blueprint(auth_bp, url_prefix='/auth')

mongo.init_app(app)
jwt = JWTManager(app)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
