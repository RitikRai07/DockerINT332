const express = require('express');
const path = require('path');

const app = express();
const PORT = 3000;

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Routes
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Frontend App</title>
      <style>
        body { font-family: Arial; text-align: center; margin-top: 50px; }
        h1 { color: #333; }
      </style>
    </head>
    <body>
      <h1>🚀 Frontend App Running</h1>
      <p>Connected to backend API</p>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`Frontend running on port ${PORT}`);
});
