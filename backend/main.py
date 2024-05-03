from flask import Flask, request, jsonify
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer

app = Flask(__name__)
nltk.download('vader_lexicon')
sia = SentimentIntensityAnalyzer()

@app.route('/')
def hello_world():
    return 'Hello to the World of Flask!'

@app.route('/input', methods=['GET'])
def inputFromUser():
    user_input = request.args.get('user_input')
    if not user_input:
        return jsonify({'res': 'No input provided!', 'sender': 'backend'}), 400

# Do text cleaning, text preprocessing, tokenization ,etc
    character_count = len(user_input)

    # check if character count exceeds 250
    if character_count > 250:
        return jsonify({'res': 'Input exceeds 250 characters!', 'sender': 'backend'}), 400

    scores = sia.polarity_scores(user_input)
    compound = scores['compound']
    sentiment = 'neutral'
    if compound > 0.05:
        sentiment = 'positive'
    elif compound < -0.05:
        sentiment = 'negative'

    return jsonify({'res': f'Input with length {character_count}.\n' f'Your message seems {sentiment}.', 
                    'sender': 'backend'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)