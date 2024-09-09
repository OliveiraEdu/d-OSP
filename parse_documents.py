from tika import parser

def parse_document(filepath):

    parsed_document = parser.from_file(filepath)
    print(parsed_document)
    print(type(parsed_document))
    print(parsed_document.keys()) 
    print(parsed_document['metadata'])  
    print(type(parsed_document['metadata']))
    print(parsed_document['status'],type(parsed_document['status'] ))
