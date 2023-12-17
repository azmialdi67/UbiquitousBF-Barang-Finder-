from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from datetime import datetime
import mysql.connector

app = Flask(__name__)
CORS(app)

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="123",
    database="barang_finder_app"
)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:123@localhost/barang_finder_app'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
ma = Marshmallow(app)

class ProductPost(db.Model):
    __tablename__ = 'product_post'
    product_post_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'))
    product_name = db.Column(db.String(255))
    description = db.Column(db.Text)
    harga = db.Column(db.Float)
    lokasi_barang = db.Column(db.String(255))
    foto_barang = db.Column(db.String(255))
    created_at = db.Column(db.TIMESTAMP)
    user = db.relationship('User', backref=db.backref('product_posts', lazy=True))

class User(db.Model):
    __tablename__ = 'user'
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255))
    email = db.Column(db.String(255))
    password = db.Column(db.String(255))
    created_at = db.Column(db.TIMESTAMP)

class ProductPostSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = ProductPost

class UserSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = User

product_post_schema = ProductPostSchema()
user_schema = UserSchema()

@app.route('/get_products', methods=['GET'])
def get_products():
    try:
        products = ProductPost.query.all()
        result = product_post_schema.dump(products, many=True)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/add_product', methods=['POST'])
def add_product():
    try:
        data = request.get_json()
        product_name = data['productName']
        description = data['description']
        harga = data['harga']
        location = data['location']
        image_path = data['imagePath']
        new_product = ProductPost(
            user_id=1,  # Ganti dengan ID user yang sesuai
            product_name=product_name,
            description=description,
            harga_barang=harga,
            lokasi_barang=location,
            foto_barang=image_path,
            created_at=datetime.now(),
        )
        db.session.add(new_product)
        db.session.commit()
        return jsonify({"message": "Product added successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
