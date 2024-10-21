import 'package:flutter/material.dart';

class EventFilterProvider extends ChangeNotifier {
  String? _selectedEventType;
  List<String> _eventTypes = [];

  String? get selectedEventType => _selectedEventType;
  List<String> get eventTypes => _eventTypes;

  void selectEventType(String? newType) {
    _selectedEventType = newType;
    notifyListeners();
  }

  void updateEventTypes(List<String> newTypes) {
    _eventTypes = newTypes;
    notifyListeners();
  }
}
