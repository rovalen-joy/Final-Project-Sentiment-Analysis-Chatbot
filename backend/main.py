# Import necessary modules and libraries
from flask import Flask, request, jsonify
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk.tokenize import word_tokenize
from nltk import pos_tag

# Initialize Flask app
app = Flask(__name__)

# Download necessary NLTK resources
nltk.download('vader_lexicon')
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')

# Initialize SentimentIntensityAnalyzer from NLTK
sia = SentimentIntensityAnalyzer()

#Define the route for the root URL
@app.route('/')
def hello_world():
    return 'Hello to the World of Flask!'

# Define the route to handle user input via GET method
@app.route('/input', methods=['GET'])
def inputFromUser():
    #Retrieve the user input from the query parameters
    user_input = request.args.get('user_input')
    
    #Return an error message if no input is provided
    if not user_input:
        return jsonify({'res': 'No input provided!', 'sender': 'backend'}), 400

    # Calculate the number of characters in the input text
    character_count = len(user_input)
    # check if character count exceeds 250
    if character_count > 250:
        return jsonify({'res': 'Input exceeds 250 characters!', 'sender': 'backend'}), 400

    # Tokenize the input text
    tokens = word_tokenize(user_input)

    # Perform POS tagging
    pos_tags = pos_tag(tokens)
    pos_counts = {}
    for _, tag in pos_tags:
        pos_counts[tag] = pos_counts.get(tag, 0) + 1

    # Calculate the sentiment of the input
    scores = sia.polarity_scores(user_input)
    compound = scores['compound']
    sentiment = 'Neutral'
    if compound > 0.05:
        sentiment = 'Positive'
    elif compound < -0.05:
        sentiment = 'Negative'

    # Return response with character count, POS counts, and sentiment analysis result
    return jsonify({'res': f'Total number of characters of the input text: {character_count} \n' 
                    f'\nThe Part-of-Speech counts: {pos_counts} \n'
                    f'\nThe sentiment of the text is {sentiment}. \n', 
                    'sender': 'backend'})

# Run the Flask app if this script is executed directly
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)