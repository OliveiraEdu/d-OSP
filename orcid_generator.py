import random

def generate_orcid():
    orcid = ""
    for i in range(16):
        orcid += str(random.randrange(0, 10))
    return orcid

