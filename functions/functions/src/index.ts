import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getFunctions } from "firebase-admin/functions";
import { changeMemoryInFirestore } from "./change-memory";
import { sendNewMemoryNotification } from "./send-memory-notification";
import { GoogleAuth } from "google-auth-library";

admin.initializeApp();

/**
 * Get the URL of a given v2 cloud function.
 *
 * @param {string} name the function's name
 * @param {string} location the function's location
 * @return {Promise<string>} The URL of the function
 */
async function getFunctionUrl(name: string, location="us-central1") {
    const auth = new GoogleAuth({
        scopes: "https://www.googleapis.com/auth/cloud-platform",
    });
    const projectId = await auth.getProjectId();
    const url = "https://cloudfunctions.googleapis.com/v2beta/" +
      `projects/${projectId}/locations/${location}/functions/${name}`;
  
    const client = await auth.getClient();
    const res = await client.request<any>({url});
    const uri = res.data?.serviceConfig?.uri;
    if (!uri) {
      throw new Error(`Unable to retreive uri for function at ${url}`);
    }
    return uri;
}

export const scheduleChangeMemory = functions.pubsub
// .schedule("0 9 * * *")
  .schedule("every 3 minutes")
  .timeZone("America/New_York")
  .onRun(async (context) => {
    // const minDelay = 0; // Minimum delay in minutes
    // const maxDelay = 14 * 60; // Maximum delay in minutes (14 hours)
    // const randomDelay = Math.floor(Math.random() * (maxDelay - minDelay + 1)) + minDelay; // Generate random delay in minutes
    // const delayMilliseconds = randomDelay * 60 * 1000; // Convert delay to milliseconds
    // const targetTime = new Date(Date.now() + delayMilliseconds);
    const targetTime = new Date(Date.now() + 5000);

    const queue = getFunctions().taskQueue("changeMemory");
    const targetUri = await getFunctionUrl("changeMemory");

    queue.enqueue({targetTime}, {
        uri: targetUri
    });
});

export const changeMemory = functions.tasks
  .taskQueue()
  .onDispatch(async (data) => {
    const ok = await changeMemoryInFirestore();
    if (ok) {
        await sendNewMemoryNotification();
    }
});