import json
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker()

# Sample data to select from
funding_agencies = [
    "National Science Foundation", "United Nations Environment Programme", "World Wildlife Fund",
    "European Union Horizon 2020", "Bill and Melinda Gates Foundation", "National Geographic Society",
    "National Institutes of Health", "Food and Agriculture Organization", "Department of Energy",
    "Asian Development Bank"
]

locations = [
    "Los Angeles, California, USA", "Svalbard, Norway", "Accra, Ghana", "Phuket, Thailand",
    "Berlin, Germany", "Kigali, Rwanda", "Amazon Rainforest, Brazil", "Yellowstone National Park, USA",
    "Tokyo, Japan", "Lagos, Nigeria", "Rotterdam, Netherlands", "Rajasthan, India",
    "Cape Town, South Africa", "Lisbon, Portugal", "Bangkok, Thailand"
]

# Sample topics and keywords
topics = [
    {
        "title": "Investigating the Role of {subject} in {context}",
        "abstract": "This study explores the impact of {subject} in {context}, focusing on {impact}.",
        "subjects": ["AI", "blockchain", "renewable energy", "urban sprawl", "climate change"],
        "contexts": ["urban development", "sustainable agriculture", "marine ecosystems", "disaster response", "carbon neutrality"],
        "impacts": ["public health", "biodiversity", "economic empowerment", "pollution mitigation", "ecosystem services"]
    },
    {
        "title": "Exploring the Effects of {subject} on {context}",
        "abstract": "This study aims to investigate the effects of {subject} on {context} and propose strategies for improvement.",
        "subjects": ["e-waste", "deforestation", "ocean currents", "wildlife monitoring", "telehealth"],
        "contexts": ["coastal communities", "soil contamination", "agriculture", "public safety", "rural healthcare"],
        "impacts": ["sustainability", "ecosystem health", "resource optimization", "disaster management", "health outcomes"]
    }
]

# Function to generate random dates
def random_date(start_year=2018, end_year=2024):
    start_date = datetime.strptime(f'{start_year}-01-01', '%Y-%m-%d')
    end_date = datetime.strptime(f'{end_year}-12-31', '%Y-%m-%d')
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

# Function to create a single synthetic entry in JSON-LD format
def generate_synthetic_entry_ld():
    topic = random.choice(topics)
    
    subject = random.choice(topic['subjects'])
    context = random.choice(topic['contexts'])
    impact = random.choice(topic['impacts'])
    
    title = topic['title'].format(subject=subject, context=context)
    abstract = topic['abstract'].format(subject=subject, context=context, impact=impact)
    
    keywords = [subject, context, impact]
    start_date = random_date()
    end_date = start_date + timedelta(days=random.randint(365, 1460))  # Project length between 1-4 years
    
    # JSON-LD formatted entry
    entry = {
        "@context": {
            "schema": "http://schema.org/",
            "dc": "http://purl.org/dc/terms/"
        },
        "@type": "schema:ResearchProject",
        "schema:name": title,
        "dc:abstract": abstract,
        "schema:keywords": keywords,
        "schema:startDate": start_date.strftime('%Y-%m-%d'),
        "schema:endDate": end_date.strftime('%Y-%m-%d'),
        "schema:funding": {
            "@type": "schema:Organization",
            "schema:name": random.choice(funding_agencies)
        },
        "schema:location": {
            "@type": "schema:Place",
            "schema:name": random.choice(locations)
        }
    }
    
    return entry

