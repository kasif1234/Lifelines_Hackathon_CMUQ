import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarAdmin extends StatelessWidget {
  const SidebarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Container(
        color: Color(0xFFF8FAFC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.dashboard, color: Color.fromARGB(255, 16, 134, 185)),
              onPressed: () {
                context.go('/admin');
              },
            ),
            IconButton(
              icon: Icon(Icons.inbox, color: Color.fromARGB(255, 16, 134, 185)),
              onPressed: () {
                context.go('/adminrequests');
              },
            ),
            SizedBox(height: 40),
            IconButton(
              icon: Icon(Icons.logout, color: Color.fromARGB(255, 16, 134, 185)),
              onPressed: () {
                context.go('/adminlogin');
              },
            ),
          ],
        ),
      ),
    );
  }
}