import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mcuapi {
  String apiurl = "http://192.168.4.1:5000";

  // Stream that emits system status data only when it changes
  Stream<double> getSystemStatusStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/system-status'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final value = data['status'];
          final currentValue = value != null ? (value as num).toDouble() : 0.0;
          
          // Only yield if value changed or it's the first value
          if (previousValue == null || previousValue != currentValue) {
            previousValue = currentValue;
            yield currentValue;
          }
        } else if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0; // First fallback value
        }
      } catch (e) {
        if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0; // First fallback value
        }
      }
    }
  }

  // Stream that emits battery percentage data only when it changes
  Stream<double> getBatteryPercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/battery'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final value = data['percentage'];
          final currentValue = value != null ? (value as num).toDouble() : 0.0;
          
          if (previousValue == null || previousValue != currentValue) {
            previousValue = currentValue;
            yield currentValue;
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

  // Stream that emits people percentage data only when it changes
  Stream<double> getPeoplePercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/people'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final value = data['percentage'];
          final currentValue = value != null ? (value as num).toDouble() : 0.0;
          
          if (previousValue == null || previousValue != currentValue) {
            previousValue = currentValue;
            yield currentValue;
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

  // Stream that emits water percentage data only when it changes
  Stream<double> getWaterPercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/water'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final value = data['percentage'];
          final currentValue = value != null ? (value as num).toDouble() : 0.0;
          
          if (previousValue == null || previousValue != currentValue) {
            previousValue = currentValue;
            yield currentValue;
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

  // Stream that emits soap percentage data only when it changes
  Stream<double> getSoapPercentageStream() async* {
    double? previousValue;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final response = await http.get(
          Uri.parse('$apiurl/soap'),
        ).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final value = data['percentage'];
          final currentValue = value != null ? (value as num).toDouble() : 0.0;
          
          if (previousValue == null || previousValue != currentValue) {
            previousValue = currentValue;
            yield currentValue;
          }
        } else if (previousValue == null) {
          previousValue = 0.0;
          yield 0.0;
        }
      } catch (e) {
        print('Error fetching soap percentage: $e');
        yield 0.0; // Fallback value
      }
    }
  }
}