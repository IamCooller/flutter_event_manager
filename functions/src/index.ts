/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Timestamp, FieldValue } = admin.firestore;
admin.initializeApp(); // Инициализация Firebase Admin SDK
const db = admin.firestore(); // Подключение к Firestore

interface EventData {
	title: string;
	description: string;
	date: typeof Timestamp;
	location: string;
	organizer: string;
	eventType: string;
	updatedAt?: typeof FieldValue;
}

import { Request, Response } from "express";

exports.createEvent = functions.https.onRequest(async (req: Request, res: Response) => {
	const eventData = req.body;

	try {
		const docRef = await db.collection("events").add({
			...eventData,
			updatedAt: admin.firestore.FieldValue.serverTimestamp(), // Добавляем timestamp
		});
		res.status(200).send({ id: docRef.id });
	} catch (error: any) {
		res.status(500).send({ error: error.toString() });
	}
});
exports.getAllEvents = functions.https.onRequest(async (req: Request, res: Response) => {
	try {
		const snapshot = await db.collection("events").get();
		const events = snapshot.docs.map((doc: { id: any; data: () => any }) => ({
			id: doc.id,
			...doc.data(),
		}));
		res.status(200).send(events);
	} catch (error: any) {
		res.status(500).send({ error: error.toString() });
	}
});
exports.getEventById = functions.https.onRequest(async (req: Request, res: Response) => {
	const { id } = req.query;

	try {
		const eventDoc = await db.collection("events").doc(id).get();

		if (!eventDoc.exists) {
			res.status(404).send("Event not found");
		} else {
			res.status(200).send(eventDoc.data());
		}
	} catch (error: any) {
		res.status(500).send({ error: error.toString() });
	}
});
exports.updateEvent = functions.https.onRequest(async (req: Request, res: Response) => {
	const { id } = req.query;
	const updatedData = req.body;

	try {
		await db
			.collection("events")
			.doc(id)
			.update({
				...updatedData,
				updatedAt: admin.firestore.FieldValue.serverTimestamp(),
			});
		res.status(200).send("Event updated successfully");
	} catch (error: any) {
		res.status(500).send({ error: error.toString() });
	}
});
exports.deleteEvent = functions.https.onRequest(async (req: Request, res: Response) => {
	const { id } = req.query;

	try {
		await db.collection("events").doc(id).delete();
		res.status(200).send("Event deleted successfully");
	} catch (error: any) {
		res.status(500).send({ error: error.toString() });
	}
});
exports.updateTimestamp = functions.firestore.document("events/{eventId}").onWrite((change: { after: { data: () => any; ref: { update: (arg0: { updatedAt: any }) => any } } }, context: any) => {
	const newValue = change.after.data();

	if (!newValue) {
		return null;
	}

	return change.after.ref.update({
		updatedAt: admin.firestore.FieldValue.serverTimestamp(),
	});
});
