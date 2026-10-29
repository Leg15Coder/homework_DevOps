from flask import Flask, jsonify
import os
import redis
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

# Получаем настройки из ENV (передаются через CI/CD или K8s Secrets)
REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_NAME = os.getenv('DB_NAME', 'gadgetstore')
DB_USER = os.getenv('DB_USER', 'gadget')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'gadget123')

# Демо-данные (в реальном проекте - из БД)
PRODUCTS = [
    {"id": 1, "name": "iPhone 15 Pro", "type": "phone", "price": 120000},
    {"id": 2, "name": "Galaxy S24 Ultra", "type": "phone", "price": 115000},
    {"id": 3, "name": "Pixel 8 Pro", "type": "phone", "price": 95000},
    {"id": 4, "name": "iPad Air M2", "type": "tablet", "price": 85000},
    {"id": 5, "name": "iPad Pro 12.9", "type": "tablet", "price": 130000}
]

@app.route('/health')
def health():
    """Эндпоинт для Smoke Test"""
    return jsonify({"status": "ok"}), 200

@app.route('/api/products')
def get_products():
    """Возвращает список товаров"""
    try:
        # Проверка связи с Redis (опционально, для демо)
        r = redis.Redis(host=REDIS_HOST, port=6379, db=0, decode_responses=True)
        r.ping()

        # Проверка связи с Postgres (опционально, для демо)
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASSWORD)
        cur = conn.cursor()
        cur.execute("SELECT 1")
        cur.close()
        conn.close()

        return jsonify(PRODUCTS), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
