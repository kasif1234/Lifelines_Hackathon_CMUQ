import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:facilitytracker/facilityScreen/requests.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    RequestsScreen.addListener(_updateUnreadCount);
    _updateUnreadCount();
  }

  @override
  void dispose() {
    RequestsScreen.removeListener(_updateUnreadCount);
    super.dispose();
  }

  void _updateUnreadCount() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _unreadCount = RequestsScreen.getUnreadCount();
          });
        }
      });
    }
  }

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
            icon: Icon(Icons.home, color: Color.fromARGB(255, 16, 134, 185)),
            onPressed: () {
              context.go('/facility');
            },
          ),
      
          IconButton(
            icon: Icon(Icons.sensors, color: Color.fromARGB(255, 16, 134, 185)),
            onPressed: () {
              context.go('/sensors');
            },
      
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.send, color: Color.fromARGB(255, 16, 134, 185)),
                onPressed: () {
                  context.go('/requests');
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
            icon: Icon(Icons.admin_panel_settings, color: Color.fromARGB(255, 16, 134, 185)),
            onPressed: () {
              context.go('/adminlogin');
            },
          ),
        ],),
      ),
    );
  }
}