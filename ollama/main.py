# import requests
# import json

# url = "http://localhost:11434/api/generate"

# data = {
#     "model": "llama3.2",
#     "prompt": "Just give only one word in your answer. What is part of speech 'house'?",
#     "stream": False,
#     "raw": True,
#     "keep_alive": 0
# }

# try:
#     response = requests.post(url, json=data, stream=False)

#     # Kiểm tra mã trạng thái
#     if response.status_code == 200:
#         try:
#             # Phản hồi dạng JSON
#             response_data = response.json()
#             print(json.dumps(response_data, indent=4))
#         except json.JSONDecodeError:
#             # Phản hồi không phải JSON
#             print("Response is not JSON:")
#             print(response.json())
#     else:
#         print(f"Error: {response.status_code}")
#         print(response.text)

# except requests.exceptions.RequestException as e:
#     print(f"Request failed: {e}")

import ollama

# modelfile = """
# FROM llava
# SYSTEM You are tasked with strictly verifying an English word based on the following criteria: IPA, part of speech (POS), example usage, and meaning. Your response must only be "correct" or "incorrect." Do not provide any additional information or explanations. Example: word: adulthood, ipa: /ˈæd.ʌlt.hʊd/, pos: noun, example: People in America legally reach adulthood at 18, meaning: the part of someone's life when they are an adult
# PARAMETER temperature 0.5
# """

# This is for user-assistant
modelfile = """
FROM llama3.2
SYSTEM Pretend to be an English teacher named John. If it is not related to English, answer I don’t know. Besides being a teacher, you are also a funny and simple person. Therefore, your answer is funny, short and easy to understand.
"""
# SYSTEM Hãy đóng vai một người dạy tiếng anh tên là John. Hãy trả lời không biết nếu không liên quan đến tiếng anh. Không chỉ là người thầy bạn còn là một người vui tính và đơn giản. Do đó mà câu trả lời của bạn có phong cách vui nhộn, ngắn ngọn và dễ hiểu.



modelfile = """
FROM llava
SYSTEM You are a english teacher. List descriptive vocabulary words that accurately represent or describe the contents and elements of the image.
"""
ollama.create("assistant-searcher-vocab", modelfile=modelfile)

# res = ollama.generate(model="user-assistant", prompt="Viết đoạn văn bảng tiếng anh ngắn về home")#word: academic, ipa: /ˌæk.əˈdem.ɪk/, pos: adjective, example: an academic institutionasdfaksjldf, meaning: relating to schools, colleges, and universities, or connected with studying and thinking, not with practical skills")
# print(res)
# print(res["response"])