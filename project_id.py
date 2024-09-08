import uuid


def generate_project_id():
    result = str(uuid.uuid4().int % (10**5))
    return result