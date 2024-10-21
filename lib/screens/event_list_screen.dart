import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/event_filter_provider.dart';
import 'event_detail_screen.dart';
import 'add_event_form.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final CollectionReference events =
      FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<EventFilterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Manager'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventForm()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Используем StreamBuilder для отслеживания изменений в коллекции событий
          StreamBuilder<QuerySnapshot>(
            stream: events.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              // Извлекаем уникальные типы событий
              List<String> fetchedEventTypes = snapshot.data!.docs
                  .map((doc) => doc['eventType'] as String)
                  .toSet()
                  .toList();

              if (!fetchedEventTypes.contains('All Events')) {
                fetchedEventTypes.insert(0, 'All Events');
              }

              // Обновляем типы событий через Provider
              filterProvider.updateEventTypes(fetchedEventTypes);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: filterProvider.selectedEventType,
                  hint: const Text('Select Event Type'),
                  items: filterProvider.eventTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    filterProvider.selectEventType(newValue);
                  },
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (filterProvider.selectedEventType == null ||
                      filterProvider.selectedEventType == 'All Events')
                  ? events.snapshots()
                  : events
                      .where('eventType',
                          isEqualTo: filterProvider.selectedEventType)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final eventDocs = snapshot.data!.docs;

                if (eventDocs.isEmpty) {
                  return const Text('No events found for the selected type');
                }

                return ListView.builder(
                  itemCount: eventDocs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> event =
                        eventDocs[index].data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(event['title']),
                      subtitle: Text(event['location']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(
                              eventId: eventDocs[index]
                                  .id, // Передаем только ID события.
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
