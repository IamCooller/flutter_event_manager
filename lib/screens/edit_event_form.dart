import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventForm extends StatefulWidget {
  final String eventId; // ID event to edit.
  final Map<String, dynamic> eventData; // Current event data.

  const EditEventForm(
      {super.key, required this.eventId, required this.eventData});

  @override
  _EditEventFormState createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _organizerController;
  late TextEditingController _eventTypeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.eventData['title']);
    _descriptionController =
        TextEditingController(text: widget.eventData['description']);
    _locationController =
        TextEditingController(text: widget.eventData['location']);
    _organizerController =
        TextEditingController(text: widget.eventData['organizer']);
    _eventTypeController =
        TextEditingController(text: widget.eventData['eventType']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _eventTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _organizerController,
                decoration: const InputDecoration(labelText: 'Organizer'),
              ),
              TextFormField(
                controller: _eventTypeController,
                decoration: const InputDecoration(labelText: 'Event Type'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateEvent(
                      widget.eventId,
                      _titleController.text,
                      _descriptionController.text,
                      _locationController.text,
                      _organizerController.text,
                      _eventTypeController.text,
                      context,
                    ).then((_) {
                      Navigator.pop(
                          context, true); // Return the result as "true"
                    });
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to update the event data in Firestore.
  Future<void> updateEvent(
      String eventId,
      String title,
      String description,
      String location,
      String organizer,
      String eventType,
      BuildContext context) async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    try {
      await events.doc(eventId).update({
        'title': title,
        'description': description,
        'location': location,
        'organizer': organizer,
        'eventType': eventType,
        'updatedAt': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully')),
      );
      // Return to the previous screen after updating the event.
      Navigator.pop(context, true); // Return the result as "true"
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $error')),
      );
    }
  }
}
