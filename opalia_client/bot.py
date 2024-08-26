from flask import Flask, request, jsonify
from langchain_google_genai import ChatGoogleGenerativeAI

# Insert your Gemini API key here
YOUR_API_KEY = "AIzaSyCya7xA83Cig9kOeRX0XQxrB22fJ6sA7yM"

# Define the modified prompt outside the loop
modified_prompt = f"""
Objective: You are Medilink Assistant, an exceptional customer support representative for Medilink TN, a company that connects health professionals with their peers and patients. Answer questions and provide resources about the company and anything related to the medical field, ONLY. 
You can give basic medical advice about health to make someone feel better. Just don't give any medicines.
Give possibilities of what may have caused the patients' illness if any are presented to you. 

User query: {{user_input}}

Style: be kind and understanding. Don't write too much. Answer in the language the question has been asked in. Any questions asked answer generally, but not too general. Offer solutions if problems are imposed. Don't give medicines that require medical assistance to patients. Redirect patients to visiting a doctor if they don't feel too well.
When pro-health questions are asked, answer scientifically. Answer with clear information. Give the latest data based on the last update you got. Don't tell people you're out of date (if you are) unless they say that. 

Boundaries: Never answer anything unrelated to the Health Industry in general and Health-tech.
"""

def generate_response(prompt):
  """Sends a prompt to the Gemini API and returns the generated response."""
  try:
    # Use ChatGoogleGenerativeAI class
    genai_model = ChatGoogleGenerativeAI(model="gemini-pro", api_key=YOUR_API_KEY)
    final_prompt = modified_prompt.format(user_input=prompt)  # Insert user input
    response = genai_model.invoke(final_prompt)
    return response.content.strip()
  except Exception as e:
    print(f"An error occurred: {e}")
    return "Sorry, I encountered an issue. Please try again later."

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    user_input = request.json['message']
    response = generate_response(user_input)
    return jsonify({'response': response})

if __name__ == '__main__':
   app.run(debug=True, host='0.0.0.0', port=5000)

while True:
  # Get user input
  user_input = input("You: ")
  if user_input.lower() == "quit":
    break

  # Generate response using ChatGoogleGenerativeAI with modified prompt
  response = generate_response(prompt=user_input)
  print(f"Opalia Assistant: {response}")

print("Thank you for chatting!")



