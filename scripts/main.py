import sqlite3

# Create database
conn = sqlite3.connect("dict.db")
cursor = conn.cursor()

# Create table
cursor.execute("""
CREATE TABLE dictionary (
    word TEXT PRIMARY KEY,
    meaning TEXT
)
""")

# Sample data (you can expand later)
data = [
    ("apple", "A fruit that is red or green."),
    ("computer", "An electronic machine that processes data."),
    ("flutter", "A UI toolkit by Google."),
    ("pdf", "A file format used for documents."),
    ("algorithm", "A step-by-step procedure to solve a problem."),
    ("data", "Information processed or stored by a computer."),
    ("network", "A group of connected computers."),
    ("memory", "Storage used by a computer."),
    ("variable", "A value that can change in a program."),
    ("function", "A block of code that performs a task.")
]

cursor.executemany("INSERT INTO dictionary VALUES (?, ?)", data)

conn.commit()
conn.close()

print("✅ dict.db created successfully!")