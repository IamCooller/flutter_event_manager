import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey =
      GlobalKey<FormState>(); // Key for the form to access its state.
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
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
                    // IF all fields are filled, call the addEvent function.
                    addEvent(
                      _titleController.text,
                      _descriptionController.text,
                      _locationController.text,
                      _organizerController.text,
                      _eventTypeController.text,
                      context,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill out all required fields')),
                    );
                  }
                },
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to add an event to Firestore.
  Future<void> addEvent(String title, String description, String location,
      String organizer, String eventType, BuildContext context) async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    try {
      await events.add({
        'title': title,
        'description': description,
        'date': Timestamp.now(),
        'location': location,
        'organizer': organizer,
        'eventType': eventType,
        'updatedAt': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully')),
      );
      Navigator.pop(
          context); // Return to the previous screen after adding the event.
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event: $error')),
      );
    }
  }
}
