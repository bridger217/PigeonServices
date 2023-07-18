import * as admin from 'firebase-admin';

export async function changeMemoryInFirestore(): Promise<Boolean> {
    const firestore = admin.firestore();

    try {
        const batch = firestore.batch();
        const memoriesRef = firestore.collection('memories');
    
        // Step 1: Update documents with "status" = "current" to "status" = "past"
        const currentQuerySnapshot = await memoriesRef.where('status', '==', 'current').get();
    
        currentQuerySnapshot.forEach((doc) => {
          const docRef = memoriesRef.doc(doc.id);
          batch.update(docRef, { status: 'past' });
        });
    
        // Step 2: Select a random document with "status" = "future" and set "status" = "current"
        const futureQuerySnapshot = await memoriesRef.where('status', '==', 'future').get();
    
        if (!futureQuerySnapshot.empty) {
          const randomIndex = Math.floor(Math.random() * futureQuerySnapshot.size);
          const randomDoc = futureQuerySnapshot.docs[randomIndex];
          const docRef = memoriesRef.doc(randomDoc.id);
          batch.update(docRef, { status: 'current' });
        }
    
        // Commit the batch write transaction atomically
        await batch.commit();
        console.log('Succesfully changed memory.')
        return true;
      } catch (error) {
        console.error('Error updating memory:', error);
        return false;
      }
}