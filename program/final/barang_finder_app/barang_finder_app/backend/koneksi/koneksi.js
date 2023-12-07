const mysql = require ('mysql');

// Konfigurasi koneksi ke database
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123',
    database: 'barang_finder_app'
  });

  db.connect((err) => {
    if (err) {
      console.error('Kaga bisa konek ke database:', err.stack);
      throw err;
    }
    console.log('Yoyoy konek ke database');
  });

    // Tangani peristiwa jika koneksi terputus
    db.on('error', (err) => {
      console.error('Koneksi database terputus:', err.message);
      if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        // Coba membuat koneksi baru
        createConnection();
      } else {
        throw err;
      }
    });
  
    return db;    
    

  
 module.exports = db