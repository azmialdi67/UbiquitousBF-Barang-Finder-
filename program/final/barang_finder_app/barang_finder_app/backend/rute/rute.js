const express = require('express');
const rute = express.Router();
const db = require('../koneksi/koneksi');


// Endpoint untuk mendapatkan data dari tabel 'like'
rute.get('/likes', (req, res) => {
  db.query('SELECT * FROM `like`', (error, results, fields) => {
    if (error) {
      console.error('Ada masalah bray pas buka tabel "like" :', error);
      return res.status(500).json({ error: 'Ada masalah bray makanya ga bisa buka tabelnya :(' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Tabel "like" kosong' });
    }

    res.json(results);
  });
});

// Endpoint untuk mendapatkan data dari tabel 'post'
rute.get('/posts', (req, res) => {
  db.query('SELECT * FROM post', (error, results, fields) => {
    if (error) {
      console.error('Ada masalah bray pas buka tabel "post" :', error);
      return res.status(500).json({ error: 'Ada masalah bray makanya ga bisa buka tabelnya :(' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Tabel "Post" kosong' });
    }

    res.json(results);
  });
});

// Endpoint untuk mendapatkan data dari tabel 'product_post'
rute.get('/product_posts', (req, res) => {
  db.query('SELECT * FROM product_post', (error, results, fields) => {
    if (error) {
      console.error('Ada masalah bray pas buka product_tabel "post" :', error);
      return res.status(500).json({ error: 'Ada masalah bray makanya ga bisa buka tabelnya :(' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Tabel "product_post" kosong' });
    }

    res.json(results);
  });
});

// Endpoint untuk mendapatkan data dari tabel 'user'
rute.get('/users', (req, res) => {
  db.query('SELECT * FROM user', (error, results, fields) => {
    if (error) {
      console.error('Ada masalah bray pas buka tabel "user" :', error);
      return res.status(500).json({ error: 'Ada masalah bray makanya ga bisa buka tabelnya :(' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Tabel "user" kosong' });
    }

    res.json(results);
  });
});

module.exports = rute;
