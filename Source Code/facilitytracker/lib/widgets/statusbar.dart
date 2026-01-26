import 'package:flutter/material.dart';

class Statusbar extends StatelessWidget {
  final IconData icon;
  final String title;
  const Statusbar(
    {super.key, required this.icon, required this.title});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.wifi, color: Colors.white),
          Icon(Icons.battery_full, color: Colors.white),
          Text(
            "12:45 PM",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}