import uuid

def generate_project_id():
    return str(uuid.uuid4().int % (10**5))

print(generate_project_id())