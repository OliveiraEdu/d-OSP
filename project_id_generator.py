import random

def generate_project_id():
    return str(random.randint(0, 99999)).zfill(5)