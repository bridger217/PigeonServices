const express = require('express');
const path = require('path');
const fs = require('fs');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;
const imagesDirectory = '/Users/bridgedudley/Desktop/PigeonFiles';
const completedDirectory = path.join(imagesDirectory, 'completed');

// Create the 'completed' directory if it doesn't exist
if (!fs.existsSync(completedDirectory)) {
  fs.mkdirSync(completedDirectory);
}

// Get a random image from the 'images' directory
function getRandomImage() {
  const imageFiles = fs.readdirSync(imagesDirectory);
  if (imageFiles.length === 0) {
    return null;
  }
  const randomIndex = Math.floor(Math.random() * imageFiles.length);
  const randomImage = imageFiles[randomIndex];
  return randomImage;
}
app.use(bodyParser.urlencoded({ extended: true }));
app.get('/', (req, res) => {
  const randomImage = getRandomImage();
  if (!randomImage) {
    res.send('No images available');
    return;
  }

  const imagePath = path.join(imagesDirectory, randomImage);
  const imageCaption = req.query.caption || '';

  const html = `
    <html>
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Image Captioning</title>
        <style>
          form {
            width: 2000px; /* Adjust the width as needed */
            margin: 0 auto;
          }

          input[type="text"],
          input[type="submit"],
          button {
            display: block;
            width: 100%;
            margin-bottom: 10px;
            padding: 5px;
            height: 300px;
            font-size: 24pt;
          }
        </style>
        </head>
        <body>
          <h1>Image Captioning</h1>
          <img src="/image?path=${encodeURIComponent(imagePath)}" alt="Image">
          <form action="/upload" method="post">
            <input type="hidden" name="path" value="${encodeURIComponent(imagePath)}">
            <input type="text" name="caption" placeholder="Enter a caption" value="${imageCaption}" required>
            <input type="submit" value="Upload">
            <button type="button" onclick="skipImage()">Skip</button>
          </form>
          <script>
            function skipImage() {
              window.location.href = '/';
            }
          </script>
        </body>
    </html>
  `;

  res.send(html);
});

// Serve the image file
app.get('/image', (req, res) => {
  const imagePath = decodeURIComponent(req.query.path);
  res.sendFile(imagePath);
});

// Handle image uploads
app.post('/upload', async (req, res) => {
  const imagePath = decodeURIComponent(req.body.path);
  const caption = req.body.caption;

  console.log(JSON.stringify({
    "path": imagePath,
    "caption": caption
  }));
  const resp = await fetch('http://localhost:3001/upload/', {
    method: 'POST',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      "path": imagePath,
      "caption": caption
    })
   });
  if (resp.status >= 400) {
    const json = await resp.json();
    console.log(`Upload failed: ${json}`);
    alert(`Upload failed: ${json}`)
  } else {
    // Move the uploaded image to the 'completed' directory
    const filename = path.basename(imagePath);
    const destinationPath = path.join(completedDirectory, filename);

    fs.renameSync(imagePath, destinationPath);

    res.redirect('/');
  }
});

// Your existing upload function that accepts an image path and a caption
function uploadImage(imagePath, caption) {
  // Implement your upload logic here
  // Example: console.log(`Uploading image '${imagePath}' with caption: '${caption}'`);
  // You can replace this with your actual implementation
  console.log(`Uploading image '${imagePath}' with caption: '${caption}'`);
}

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
