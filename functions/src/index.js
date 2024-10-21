"use strict";
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
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
exports.createEvent = functions.https.onRequest((req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const eventData = req.body;
    try {
        const docRef = yield db.collection("events").add(Object.assign(Object.assign({}, eventData), { updatedAt: admin.firestore.FieldValue.serverTimestamp() }));
        res.status(200).send({ id: docRef.id });
    }
    catch (error) {
        res.status(500).send({ error: error.toString() });
    }
}));
exports.getAllEvents = functions.https.onRequest((req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const snapshot = yield db.collection("events").get();
        const events = snapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.status(200).send(events);
    }
    catch (error) {
        res.status(500).send({ error: error.toString() });
    }
}));
exports.getEventById = functions.https.onRequest((req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.query;
    try {
        const eventDoc = yield db.collection("events").doc(id).get();
        if (!eventDoc.exists) {
            res.status(404).send("Event not found");
        }
        else {
            res.status(200).send(eventDoc.data());
        }
    }
    catch (error) {
        res.status(500).send({ error: error.toString() });
    }
}));
exports.updateEvent = functions.https.onRequest((req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.query;
    const updatedData = req.body;
    try {
        yield db
            .collection("events")
            .doc(id)
            .update(Object.assign(Object.assign({}, updatedData), { updatedAt: admin.firestore.FieldValue.serverTimestamp() }));
        res.status(200).send("Event updated successfully");
    }
    catch (error) {
        res.status(500).send({ error: error.toString() });
    }
}));
exports.deleteEvent = functions.https.onRequest((req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.query;
    try {
        yield db.collection("events").doc(id).delete();
        res.status(200).send("Event deleted successfully");
    }
    catch (error) {
        res.status(500).send({ error: error.toString() });
    }
}));
exports.updateTimestamp = functions.firestore.document("events/{eventId}").onWrite((change, context) => {
    const newValue = change.after.data();
    if (!newValue) {
        return null;
    }
    return change.after.ref.update({
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
});
