/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// import * as logger from "firebase-functions/logger";
// import {onRequest} from "firebase-functions/v2/https";
import {onCall} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp();

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const createUser = onCall(async (request) => {
  const data = request.data;
  if (!data || !data.id || !data.email) {
    throw new Error("Missing required user fields");
  }
  try {
    await admin.firestore().collection("users").doc(data.id).set(data);
    return {message: "User created successfully"};
  } catch (error: any) {
    throw new Error("Error creating user: " + (error?.message || error));
  }
});
