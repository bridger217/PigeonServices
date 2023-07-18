import * as admin from "firebase-admin";
var serviceAccount = require("/Users/bridgedudley/.pigeon_services/firebase.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

async function resetAllMemories() {
    const firestore = admin.firestore();
    const memoriesRef = firestore.collection('memories');
  
    try {
      const querySnapshot = await memoriesRef.get();
  
      const batch = firestore.batch();
  
      querySnapshot.forEach((doc) => {
        const docRef = memoriesRef.doc(doc.id);
        batch.update(docRef, {
          status: 'future',
          seen: false,
          seenDate: admin.firestore.FieldValue.delete()
        });
      });
  
      await batch.commit();
  
      console.log('Memories updated successfully.');
    } catch (error) {
      console.error('Error updating memories:', error);
    }
}
  
resetAllMemories().then(()=> {
    console.log('Done, exiting');
    return process.exit(0);
});