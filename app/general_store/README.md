# General Store Web Application

This is a simple web-based general store where customers can place orders via a browser.

## Features

1. View available products
2. Place new orders through a web form
3. View order history
4. Data persistence using `data.json` (so orders and stock survive restarts)

## How to run (Windows, using bash)

```bash
# create and activate a virtual environment (optional but recommended)
python -m venv .venv
source .venv/Scripts/activate  # on Windows with bash

# install dependencies
pip install -r requirements.txt

# run the web app
python web_app.py
```

The app will start at http://127.0.0.1:5000 and attempts to open your browser automatically.

## Files added

- `web_app.py` — Flask application (routes: `/` to view products and place order, `/orders` to view orders)
- `templates/` — HTML templates (Bootstrap) for UI
- `data.json` — product and order data (initial stock included)
- `requirements.txt` — dependencies (Flask)

## Notes & next steps

- This is a learning app. We kept it simple so you can read and extend the code.
- Next improvements you might want: product management pages (add/edit/remove), user accounts, and richer validation.

If you'd like, I can:
1. Add an admin UI to add or edit products
2. Add tests for key logic
3. Package the app for easy deployment

Which of these would you like next?