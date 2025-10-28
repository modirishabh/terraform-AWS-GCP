import os
from datetime import datetime

# Dictionary to store our products
products = {
    '1': {'name': 'Rice', 'price': 50.00, 'stock': 100},
    '2': {'name': 'Dal', 'price': 80.00, 'stock': 50},
    '3': {'name': 'Sugar', 'price': 40.00, 'stock': 75},
    '4': {'name': 'Salt', 'price': 20.00, 'stock': 100},
    '5': {'name': 'Oil', 'price': 120.00, 'stock': 30}
}

# List to store orders
orders = []

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def display_menu():
    clear_screen()
    print("\n=== Welcome to My General Store ===")
    print("1. View Products")
    print("2. Place Order")
    print("3. View Orders")
    print("4. Exit")
    return input("\nPlease select an option (1-4): ")

def view_products():
    clear_screen()
    print("\n=== Available Products ===")
    print("Code  |  Name  |  Price  |  Stock")
    print("-" * 35)
    for code, product in products.items():
        print(f"{code:4} | {product['name']:6} | ₹{product['price']:6.2f} | {product['stock']:5}")
    input("\nPress Enter to continue...")

def place_order():
    clear_screen()
    print("\n=== Place New Order ===")
    customer_name = input("Enter customer name: ")
    order_items = []
    total_amount = 0

    while True:
        view_products()
        product_code = input("\nEnter product code (or 'done' to finish): ")
        
        if product_code.lower() == 'done':
            break
            
        if product_code not in products:
            print("Invalid product code!")
            continue
            
        quantity = int(input("Enter quantity: "))
        
        if quantity <= 0:
            print("Quantity must be positive!")
            continue
            
        if quantity > products[product_code]['stock']:
            print("Not enough stock!")
            continue
            
        # Add item to order
        item_total = products[product_code]['price'] * quantity
        order_items.append({
            'product': products[product_code]['name'],
            'quantity': quantity,
            'price': products[product_code]['price'],
            'total': item_total
        })
        
        # Update stock
        products[product_code]['stock'] -= quantity
        total_amount += item_total

    if order_items:
        order = {
            'order_id': len(orders) + 1,
            'customer_name': customer_name,
            'items': order_items,
            'total_amount': total_amount,
            'date': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }
        orders.append(order)
        print(f"\nOrder placed successfully! Order ID: {order['order_id']}")
    
    input("\nPress Enter to continue...")

def view_orders():
    clear_screen()
    print("\n=== Order History ===")
    if not orders:
        print("No orders found!")
    else:
        for order in orders:
            print(f"\nOrder ID: {order['order_id']}")
            print(f"Customer: {order['customer_name']}")
            print(f"Date: {order['date']}")
            print("\nItems:")
            print("Product  |  Quantity  |  Price  |  Total")
            print("-" * 45)
            for item in order['items']:
                print(f"{item['product']:8} | {item['quantity']:9} | ₹{item['price']:6.2f} | ₹{item['total']:6.2f}")
            print(f"\nTotal Amount: ₹{order['total_amount']:.2f}")
            print("-" * 45)
    input("\nPress Enter to continue...")

def main():
    while True:
        choice = display_menu()
        if choice == '1':
            view_products()
        elif choice == '2':
            place_order()
        elif choice == '3':
            view_orders()
        elif choice == '4':
            print("\nThank you for using My General Store! Goodbye!")
            break
        else:
            print("\nInvalid option! Please try again.")
            input("\nPress Enter to continue...")

if __name__ == "__main__":
    main()