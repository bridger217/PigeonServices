import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { changeMemoryInFirestore } from "./change-memory";
import { sendNewMemoryNotification } from "./send-memory-notification";

admin.initializeApp();

export const changeMemory = functions.pubsub
// .schedule("0 9 * * *")
  .schedule("every 1 minutes")
  .timeZone("America/New_York")
  .onRun(async (context) => {
    const minDelay = 0; // Minimum delay in minutes
    const maxDelay = 1;
    // const maxDelay = 14 * 60; // Maximum delay in minutes (14 hours)
    const randomDelay = Math.floor(Math.random() * (maxDelay - minDelay + 1)) + minDelay; // Generate random delay in minutes
    const delayMilliseconds = randomDelay * 60 * 1000; // Convert delay to milliseconds

    // Calculate the target time by adding the delay to the current time
    const targetTime = new Date(Date.now() + delayMilliseconds);

    // Calculate the remaining milliseconds until the target time
    const remainingMilliseconds = targetTime.getTime() - Date.now();

    setTimeout(async () => {
        console.log(`Running change memory at ${new Date()}`);
        const ok = await changeMemoryInFirestore();
        if (ok) {
            await sendNewMemoryNotification();
        }
    }, remainingMilliseconds);
});
