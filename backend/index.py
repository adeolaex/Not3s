from flask import Flask


app = Flask(__name__)


@app.route('/')
def indexApp():
    return "Initialized"


if __name__ == "__main__":
    app.run()
