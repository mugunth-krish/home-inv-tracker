from flask import Flask, jsonify, request
from flask_cors import CORS
import uuid

app = Flask(__name__)
CORS(app)

# Mock database
items = [
    {"id": "1", "name": "Sofa", "location": "Living Room", "photoUrl": None},
    {"id": "2", "name": "Laptop", "location": "Office", "photoUrl": None}
]

@app.route("/items", methods=["GET"])
def get_items():
    return jsonify(items), 200

@app.route("/items", methods=["POST"])
def add_item():
    data = request.get_json()
    new_item = {
        "id": str(uuid.uuid4()),
        "name": data.get("name"),
        "location": data.get("location"),
        "photoUrl": data.get("photoUrl")
    }
    items.append(new_item)
    return jsonify(new_item), 201
@app.route("/items/<item_id>", methods=["DELETE"])
def delete_item(item_id):
    global items
    # Find item
    item_to_delete = next((i for i in items if i["id"] == item_id), None)

    if not item_to_delete:
        return jsonify({"error": "Item not found"}), 404

    items = [i for i in items if i["id"] != item_id]

    return jsonify({"message": "Item deleted"}), 200


if __name__ == "__main__":
    app.run(debug=True, port=5000)
