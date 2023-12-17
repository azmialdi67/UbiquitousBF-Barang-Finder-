from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from datetime import datetime
import mysql.connector

# Inisialisasi aplikasi Flask
app = Flask(__name__)
CORS(app)

# Konfigurasi database MySQL
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="123",
    database="barang_finder_app"
)

# Membuat objek SQLAlchemy
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:123@localhost/barang_finder_app'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
ma = Marshmallow(app)

# Definisi Model SQLAlchemy
class Like(db.Model):
    __tablename__ = 'likes'
    like_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'))
    post_id = db.Column(db.Integer, db.ForeignKey('post.post_id'))
    product_post_id = db.Column(db.Integer, db.ForeignKey('product_post.product_post_id'))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)

class Post(db.Model):
    __tablename__ = 'post'
    post_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'))
    content = db.Column(db.Text)
    created_at = db.Column(db.TIMESTAMP)
    user = db.relationship('User', backref=db.backref('posts', lazy=True))

class ProductPost(db.Model):
    __tablename__ = 'product_post'
    product_post_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'))
    product_name = db.Column(db.String(255))
    description = db.Column(db.Text)
    harga_barang = db.Column(db.Float)
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

# Definisi Marshmallow Schemas
class LikeSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Like

class PostSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Post

class ProductPostSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = ProductPost

class UserSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = User

like_schema = LikeSchema()
post_schema = PostSchema()
product_post_schema = ProductPostSchema()
user_schema = UserSchema()

# Rute Flask
@app.route('/likes', methods=['GET'])
def get_likes():
    likes = Like.query.all()
    return jsonify(like_schema.dump(likes, many=True))

@app.route('/posts', methods=['GET'])
def get_posts():
    posts = Post.query.all()
    return jsonify(post_schema.dump(posts, many=True))

@app.route('/product_posts', methods=['GET'])
def get_product_posts():
    product_posts = ProductPost.query.all()
    return jsonify(product_post_schema.dump(product_posts, many=True))

@app.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify(user_schema.dump(users, many=True))

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
