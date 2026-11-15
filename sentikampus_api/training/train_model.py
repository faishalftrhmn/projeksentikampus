import pickle
from pathlib import Path
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

texts = [
    # Positif
    "pelayanan cepat",
    "petugas ramah",
    "pelayanan kampus sangat baik",
    "fasilitas kampus bagus dan bersih",
    "sangat puas dengan layanan ini",
    "respon admin sangat cepat dan membantu",
    
    # Negatif
    "pelayanan lambat",
    "informasi membingungkan",
    "pelayanan kampus sangat buruk",
    "fasilitas rusak dan mengecewakan",
    "sangat tidak puas dengan layanannya",
    "petugas jutek dan tidak membantu",
]

labels = [
    "positive",
    "positive",
    "positive",
    "positive",
    "positive",
    "positive",
    "negative",
    "negative",
    "negative",
    "negative",
    "negative",
    "negative",
]

pipeline = Pipeline([
    ("tfidf", TfidfVectorizer()),
    ("model", LogisticRegression()),
])

pipeline.fit(texts, labels)

# Simpan ke folder models yang dibaca oleh backend
Path("models").mkdir(exist_ok=True)
with open("models/sentiment.pkl", "wb") as f:
    pickle.dump(pipeline, f)

print("Model baru berhasil disimpan ke models/sentiment.pkl")