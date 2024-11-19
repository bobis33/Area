from flask import make_response, Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return make_response("Supprime ou jte supprime", 200)
