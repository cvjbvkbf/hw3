import csv
import random
import os
import sys

NUM_ROWS = 100
COLUMNS = ["id", "name", "age", "job", "salary"]

def random_name():
    name = random.choice(["Антон", "Андрей", "Алексей", "Александр", "Александра", "Арина", "Алина", "Алла", "Анна", "Акрапович"])
    return f"{name}"

def random_department():
    return random.choice(["Analyst", "DevOps", "Backend", "Frontend", "HR"])

def generate_row(row_id):
    return {
        "id": row_id,
        "name": random_name(),
        "age": random.randint(18, 67),
        "job": random_department(),
        "salary": random.randint(30000, 1000000)
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row(i+1) for i in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)
