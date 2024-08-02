# Utilities to support user account data 

import random
import string
import csv
import os

def generate_orcid():
    # Generate the first part of the ORCID ID (16 digits, separated by hyphens)
    parts = [''.join(random.choice('0123456789') for _ in range(4)) for _ in range(3)] + ['X']
    return '-'.join(parts)

def print_random_from_second_column(file_path):
    with open(file_path, mode='r', newline='') as file:
        reader = csv.reader(file)
        second_column_values = [row[1] for row in reader]
        random_value = random.choice(second_column_values)
    return random_value

def dump_to_csv(account_id, user_account_full_name, user_account_email, user_account_institution, user_account_orcid, user_private_key, user_public_key, filename="datasets/accounts.csv"):
    file_exists = os.path.isfile(filename)
    with open(filename, mode='a', newline='') as file:
        writer = csv.writer(file)
        if not file_exists:
            writer.writerow(["Account ID", "Full Name", "Email", "Institution", "orcid", "Private Key", "Public Key"])
        writer.writerow([account_id, user_account_full_name, user_account_email, user_account_institution, user_account_orcid, user_private_key, user_public_key])



left = [
        "admiring", "adoring", "affectionate", "agitated", "amazing", "angry", "awesome", "beautiful", "blissful", "bold",
    "boring", "brave", "busy", "charming", "clever", "compassionate", "competent", "condescending", "confident", "cool",
    "cranky", "crazy", "dazzling", "determined", "distracted", "dreamy", "eager", "ecstatic", "elastic", "elated",
    "elegant", "eloquent", "epic", "exciting", "fervent", "festive", "flamboyant", "focused", "friendly", "frosty",
    "funny", "gallant", "gifted", "goofy", "gracious", "great", "happy", "hardcore", "heuristic", "hopeful", "hungry",
    "infallible", "inspiring", "intelligent", "interesting", "jolly", "jovial", "keen", "kind", "laughing", "loving",
    "lucid", "magical", "modest", "musing", "mystifying", "naughty", "nervous", "nice", "nifty", "nostalgic", "objective",
    "optimistic", "peaceful", "pedantic", "pensive", "practical", "priceless", "quirky", "quizzical", "recursing",
    "relaxed", "reverent", "romantic", "sad", "serene", "sharp", "silly", "sleepy", "stoic", "strange", "stupefied",
    "suspicious", "sweet", "tender", "thirsty", "trusting", "unruffled", "upbeat", "vibrant", "vigilant", "vigorous",
    "wizardly", "wonderful", "xenodochial", "youthful", "zealous", "zen"
]

right = [
        "albattani", "allen", "almeida", "antonelli", "agnesi", "archimedes", "ardinghelli", "aryabhata", "austin", "babbage",
    "banach", "bardeen", "bartik", "bassi", "beaver", "bell", "benz", "bhabha", "bhaskara", "black", "blackburn", "blackwell",
    "bohr", "booth", "borg", "bose", "boyd", "brahmagupta", "brattain", "brown", "buck", "burnell", "cabrera", "cameron",
    "carson", "cartwright", "chandrasekhar", "chaplygin", "chatelet", "chatterjee", "chebyshev", "cocks", "cohen", "cole",
    "collins", "colwell", "cori", "cray", "curran", "curie", "darwin", "davinci", "dewdney", "dhawan", "diffie", "dijkstra",
    "dirac", "driscoll", "dubinsky", "easley", "edison", "einstein", "elbakyan", "elion", "ellis", "engelbart", "euclid",
    "euler", "faraday", "feistel", "fermat", "fermi", "feynman", "franklin", "gagarin", "galileo", "galois", "gates",
    "gauss", "germain", "goldberg", "goldstine", "goldwasser", "golick", "goodall", "goose", "gould", "greider", "grothendieck",
    "haibt", "hamilton", "hawking", "heisenberg", "hermann", "herschel", "hertz", "heyrovsky", "hodgkin", "hofstadter", "hoover",
    "hopper", "hugle", "hypatia", "ishizaka", "jackson", "jang", "jemison", "jenner", "jepsen", "johnson", "joliot", "jones",
    "kalam", "kapitsa", "kare", "keldysh", "keller", "kepler", "khayyam", "khorana", "kilby", "kirch", "knuth", "kowalevski",
    "lalande", "lamarr", "lamport", "leakey", "leavitt", "lederberg", "lehmann", "lewin", "lichterman", "liskov", "lovelace",
    "lumiere", "mahavira", "margulis", "matsumoto", "maxwell", "mayer", "mccarthy", "mcclintock", "mclaren", "mclean", "mcnulty",
    "mendel", "mendeleev", "meitner", "meninsky", "merkle", "mestorf", "mirzakhani", "montalcini", "moore", "morse", "murdock",
    "moser", "napier", "nash", "neumann", "newton", "nightingale", "nobel", "noether", "northcutt", "noyce", "panini", "pare",
    "pascal", "pasteur", "payne", "perlman", "pike", "poincare", "poitras", "proskuriakova", "ptolemy", "raman", "ramanujan",
    "rhodes", "ride", "montalcini", "moore", "morse", "murdock", "moser", "napier", "nash", "neumann", "newton", "nightingale",
    "nobel", "noether", "northcutt", "noyce", "panini", "pare", "pascal", "pasteur", "payne", "perlman", "pike", "poincare",
    "poitras", "proskuriakova", "ptolemy", "raman", "ramanujan", "rhodes", "ride", "montalcini", "moore", "morse", "murdock",
    "moser", "napier", "nash", "neumann", "newton", "nightingale", "nobel", "noether", "northcutt", "noyce", "panini", "pare",
    "pascal", "pasteur", "payne", "perlman", "pike", "poincare", "poitras", "proskuriakova", "ptolemy", "raman", "ramanujan",
    "rhodes", "ride", "montalcini", "moore", "morse", "murdock", "moser", "napier", "nash", "neumann", "newton", "nightingale",
    "nobel", "noether", "northcutt", "noyce", "panini", "pare", "pascal", "pasteur", "payne", "perlman", "pike", "poincare",
    "poitras", "proskuriakova", "ptolemy", "raman", "ramanujan", "rhodes", "ride", "montalcini", "moore", "morse", "murdock",
    "moser", "napier", "nash", "neumann", "newton", "nightingale", "nobel", "noether", "northcutt", "noyce", "panini", "pare",
    "pascal", "pasteur", "payne", "perlman", "pike", "poincare", "poitras", "proskuriakova", "ptolemy", "raman", "ramanujan",
    "rhodes", "ride", "montalcini", "moore", "morse", "murdock", "moser", "napier", "nash", "neumann", "newton", "nightingale",
    "nobel", "noether", "northcutt", "noyce", "panini", "pare", "pascal", "pasteur", "payne", "perlman", "pike", "poincare",
    "poitras", "proskuriakova", "ptolemy", "raman", "ramanujan", "rhodes", "ride", "montalcini", "moore", "morse", "murdock",
    "moser", "napier", "nash", "neumann"]
