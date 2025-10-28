from flask import Flask, render_template, request, redirect, url_for, flash
import json
import os
from datetime import datetime
import webbrowser

DATA_FILE = 'data.json'

app = Flask(__name__)
app.secret_key = 'dev-secret-key'  # for flash messages

# Helpers to load/save data

def load_data():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    # default initial data
    data = {
        'products': {
            '1': {'name': 'Rice', 'price': 50.00, 'stock': 100},
            '2': {'name': 'Dal', 'price': 80.00, 'stock': 50},
            '3': {'name': 'Sugar', 'price': 40.00, 'stock': 75},
            '4': {'name': 'Salt', 'price': 20.00, 'stock': 100},
            '5': {'name': 'Oil', 'price': 120.00, 'stock': 30}
        },
        'orders': []
    }
    save_data(data)
    return data


def save_data(data):
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


@app.route('/')
def index():
    data = load_data()
    products = data['products']
    return render_template('index.html', products=products)


@app.route('/order', methods=['POST'])
def place_order():
    data = load_data()
    products = data['products']

    customer = request.form.get('customer_name', '').strip()
    product_code = request.form.get('product_code')
    try:
        quantity = int(request.form.get('quantity', '0'))
    except ValueError:
        quantity = 0

    if not customer:
        flash('Please enter customer name', 'danger')
        return redirect(url_for('index'))

    if product_code not in products:
        flash('Invalid product code selected', 'danger')
        return redirect(url_for('index'))

    if quantity <= 0:
        flash('Quantity must be at least 1', 'danger')
        return redirect(url_for('index'))

    product = products[product_code]
    if quantity > product['stock']:
        flash(f"Not enough stock for {product['name']}. Available: {product['stock']}", 'danger')
        return redirect(url_for('index'))

    item_total = product['price'] * quantity

    order = {
        'order_id': len(data['orders']) + 1,
        'customer_name': customer,
        'items': [
            {
                'code': product_code,
                'product': product['name'],
                'quantity': quantity,
                'price': product['price'],
                'total': item_total
            }
        ],
        'total_amount': item_total,
        'date': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    }

    # update stock
    products[product_code]['stock'] -= quantity

    data['orders'].append(order)
    save_data(data)

    flash(f'Order placed successfully! Order ID: {order['order_id']}', 'success')
    return redirect(url_for('orders'))


@app.route('/orders')
def orders():
    data = load_data()
    return render_template('orders.html', orders=data['orders'])


if __name__ == '__main__':
    url = 'http://127.0.0.1:5000'
    # Try to open browser automatically (may be blocked in some environments)
    try:
        webbrowser.open(url)
    except Exception:
        pass
    app.run(debug=True)
