import * as express from 'express';
import { json } from 'body-parser';
import * as admin from 'firebase-admin';
import * as fs from 'fs';
import * as path from 'path';
import { uuidv4 } from '@firebase/util';

var serviceAccount = require("/Users/bridgedudley/.pigeon_services/firebase.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: "pigeonservices-38c30.appspot.com"
});
const app = express();

app.set('trust proxy', true);
app.use(json());

async function uploadImageAndCreateMemory(imagePath: string, message: string) {
    const storage = admin.storage();
    const bucket = storage.bucket();
  
    const fileExtension = path.extname(imagePath);
      const fileName = `${uuidv4()}${fileExtension}`;
      const destinationPath = `images/${fileName}`;
      const fileBuffer = fs.readFileSync(imagePath);
  
      // Step 1: Upload the local image to Firebase Storage
      await bucket.file(destinationPath).save(fileBuffer, {
        metadata: {
            // This line is very important. It's to create a download token.
            firebaseStorageDownloadTokens: uuidv4()
        },
        contentType: 'image/jpeg',
        public: true,
      });
  
      // Step 2: Create a Firestore document in the 'memories' collection
      const firestore = admin.firestore();
      const memoriesRef = firestore.collection('memories');
  
      const memoryData = {
        imagePath: destinationPath,
        message: message,
        status: 'future',
        seen: false
      };
  
      await memoriesRef.add(memoryData);
  }

app.post('/upload',
    async (req: express.Request, res: express.Response) => {
        console.log(req.body);
        try {
            await uploadImageAndCreateMemory(req.body.path, req.body.caption);
            res.status(200).send({});
            console.log("success");
        } catch(error) {
            console.log(error);
            res.status(500).send({});
        }
    }
);

const start = async () => {
    app.listen("3001", () => {
        console.log(`Starting on port 3001!!!!!!`);
    });
};

start();