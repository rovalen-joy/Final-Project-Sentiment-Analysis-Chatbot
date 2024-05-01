from flask import Flask, request, jsonify

# init flask app
app = Flask(__name__)

# define the routes/apis
@app.route('/')
def hello_world():
    return 'Hello to the World of Flask!'
    
# set any name for your API, make sure that
# the frontend will call the same API name
@app.route('/input', methods=['GET'])
def inputFromUser():
    # get the parameter with the name input
    user_input = request.args.get('user_input')

    # Do text cleaning, text preprocessing, tokenization ,etc
    character_count = len(user_input)

    # check if character count exceeds 250
    if character_count > 250:
        return jsonify({
            'res': 'Input exceeds the limit of 250 characters!',
            'sender': 'backend'
        }), 400
    
    # create a json object to send all of the data
    return jsonify({
        'res': f'Input with length {character_count} received!',
        'sender': 'backend'
    })

# run the flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)