import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:facilitytracker/adminScreen/adminrequests.dart';

class SidebarAdmin extends StatefulWidget {
  const SidebarAdmin({super.key});

  @override
  State<SidebarAdmin> createState() => _SidebarAdminState();
}

class _SidebarAdminState extends State<SidebarAdmin> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    AdminRequestsScreen.addListener(_updateUnreadCount);
    _updateUnreadCount();
  }

  @override
  void dispose() {
    AdminRequestsScreen.removeListener(_updateUnreadCount);
    super.dispose();
  }

  void _updateUnreadCount() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _unreadCount = AdminRequestsScreen.getUnreadCount();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminColor = Color.fromARGB(255, 237, 189, 126);
    
    return SizedBox(
      width: 70,
      child: Container(
        color: Color(0xFFF8FAFC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.dashboard, color: adminColor),
              onPressed: () {
                context.go('/admin');
              },
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.send, color: adminColor),
                  onPressed: () {
                    context.go('/adminrequests');
                  },
                ),
                if (_unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        _unreadCount > 9 ? '9+' : '$_unreadCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 40),
            IconButton(
              icon: Icon(Icons.logout, color: adminColor),
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