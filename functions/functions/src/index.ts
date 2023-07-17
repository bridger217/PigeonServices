import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const changeMemory = functions.pubsub
// .schedule("0 9 * * *")
  .schedule("every 1 minutes")
  .timeZone("America/New_York")
  .onRun(async (context) => {
    //   const firestore = admin.firestore();
    const minDelay = 0; // Minimum delay in minutes
    const maxDelay = 14 * 60; // Maximum delay in minutes (14 hours)
    const randomDelay = Math.floor(Math.random() * (maxDelay - minDelay + 1)) + minDelay; // Generate random delay in minutes
    const delayMilliseconds = randomDelay * 60 * 1000; // Convert delay to milliseconds

    // Calculate the target time by adding the delay to the current time
    const targetTime = new Date(Date.now() + delayMilliseconds);

    // Calculate the remaining milliseconds until the target time
    const remainingMilliseconds = targetTime.getTime() - Date.now();
    console.log(`REMAINING MILLISECONDS: ${remainingMilliseconds}`);

    // Execute your function logic after the remaining delay
    //   setTimeout(() => {
    //     // Your function logic goes here
    //     console.log('Function executed at a random time between 9am and 11pm');
    //   }, remainingMilliseconds);
});
