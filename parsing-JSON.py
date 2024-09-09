from tika import parser 

filepath = 'upload/Deep-learning-in-insurance--Accuracy-and-model-int_2023_Expert-Systems-with-.pdf'  # Replace with the path of your file
parsed_document = parser.from_file(filepath)
print(parsed_document)