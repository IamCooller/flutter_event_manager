import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_event_form.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId; // Handle to the event to display.

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: events
            .doc(eventId)
            .snapshots(), // Get the event data using the event ID.
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('Event not found');
          }

          var eventData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${eventData['title']}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Description: ${eventData['description']}'),
                const SizedBox(height: 10),
                Text('Location: ${eventData['location']}'),
                const SizedBox(height: 10),
                Text('Organizer: ${eventData['organizer']}'),
                const SizedBox(height: 10),
                Text('Event Type: ${eventData['eventType']}'),
                const SizedBox(height: 10),
                Text('Date: ${eventData['date'].toDate().toString()}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEventForm(
                          eventId: eventId,
                          eventData:
                              eventData, // Pass the event data to the edit form.
                        ),
                      ),
                    );
                  },
                  child: const Text('Edit Event'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteEvent(eventId, context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete Event'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Function to delete an event.
  void _deleteEvent(String eventId, BuildContext context) async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    try {
      await events.doc(eventId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );
      Navigator.pop(
          context); // Return to the previous screen after deleting the event.
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $error')),
      );
    }
  }
}
