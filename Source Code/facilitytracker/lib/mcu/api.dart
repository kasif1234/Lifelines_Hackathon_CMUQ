import 'dart:async';
import 'package:http/http.dart' as http;

class Mcuapi {
  String apiurl = "http://192.168.4.1:5000";

  Stream<double> getPeoplePercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/people'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final parts = response.body.trim().split('|');
          if (parts.length >= 3 && parts[0] == 'SENS') {
            final currentValue = (double.tryParse(parts[2]) ?? 0.0) / 100.0;
            
            if (previousValue == null || previousValue != currentValue) {
              previousValue = currentValue;
              yield currentValue;
            }
          }
        } else if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0;
        }
      } catch (e) {
        if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0;
        }
      }
    }
  }

  Stream<double> getWaterPercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/water'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final parts = response.body.trim().split('|');
          if (parts.length >= 3 && parts[0] == 'SENS' && parts[1] == 'WATER') {
            final currentValue = (double.tryParse(parts[2]) ?? 0.0) / 100.0;
            
            if (previousValue == null || previousValue != currentValue) {
              previousValue = currentValue;
              yield currentValue;
            }
          }
        } else if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0;
        }
      } catch (e) {
        if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0;
        }
      }
    }
  }

  Stream<double> getSoapPercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/soap'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final parts = response.body.trim().split('|');
          if (parts.length >= 3 && parts[0] == 'SENS' && parts[1] == 'SOAP') {
            final currentValue = (double.tryParse(parts[2]) ?? 0.0) / 100.0;
            
            if (previousValue == null || previousValue != currentValue) {
              previousValue = currentValue;
              yield currentValue;
            }
          }
        } else if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0;
        }
      } catch (e) {
        print('Error fetching soap percentage: $e');
        if (previousValue == null) {
          previousValue = 0.1;
          yield 0.0;
        }
      }
    }
  }

  Future<bool> sendRefillRequest(String type) async {
    try {
      final supplyType = type.contains('Water') ? 'WATER' : 'Soap';
      final requestData = 'REQ|$supplyType';
      
      final response = await http.post(
        Uri.parse('$apiurl/refill-request'),
        headers: {'Content-Type': 'text/plain'},
        body: requestData,
      ).timeout(Duration(seconds: 5));
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error sending refill request: $e');
      return false;
    }
  }
}