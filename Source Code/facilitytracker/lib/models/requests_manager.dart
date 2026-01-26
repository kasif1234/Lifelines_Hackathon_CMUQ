import 'package:flutter/material.dart';

class RequestsManager extends ChangeNotifier {
  static final RequestsManager _instance = RequestsManager._internal();
  
  factory RequestsManager() {
    return _instance;
  }
  
  RequestsManager._internal();

  List<Map<String, dynamic>> _refillRequests = [];

  List<Map<String, dynamic>> get refillRequests => _refillRequests;

  void addRequest(String type) {
    final now = DateTime.now();
      
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeString = '$hour:$minute $period';
    
    _refillRequests.add({
      'type': type,
      'time': timeString,
      'status': 'Pending',
      'timestamp': now,
    });
    
    notifyListeners();
  }

  void removeRequest(int index) {
    if (index >= 0 && index < _refillRequests.length) {
      _refillRequests.removeAt(index);
      notifyListeners();
    }
  }

  void updateRequestStatus(int index, String newStatus) {
    if (index >= 0 && index < _refillRequests.length) {
      _refillRequests[index]['status'] = newStatus;
      notifyListeners();
    }
  }
}
