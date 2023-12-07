// index.js
const express = require('express');
const app = express();
const db = require('./koneksi/koneksi');
const rute = require('./rute/rute');  // Import file rute
const cors = require('cors')

app.use(cors())

const PORT = process.env.PORT || 4000;

// Middleware untuk menghandle body JSON pada request
app.use(express.json());

// Gunakan rute yang telah di-import
app.use('/', rute);

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint kaga ada nape lu hah?!' });
});

// Menjalankan server
app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});
