import 'package:facilitytracker/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:facilitytracker/models/requests_manager.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final RequestsManager _requestsManager = RequestsManager();

  List<Map<String, dynamic>> dailyTasks = [
    {'title': 'Check supply of water to restrooms', 'done': false, 'time': '9:00 AM'},
    {'title': 'Inspect soap dispensers in restrooms', 'done': false, 'time': '10:00 AM'},
    {'title': 'Clean restroom facilities', 'done': false, 'time': '11:00 AM'},
    {'title': 'Review sensor reports', 'done': false, 'time': '2:00 PM'},
    {'title': 'Restock paper supplies', 'done': false, 'time': '3:00 PM'},
  ];

  @override
  void initState() {
    super.initState();
    _requestsManager.addListener(_onRequestsChanged);
  }

  @override
  void dispose() {
    _requestsManager.removeListener(_onRequestsChanged);
    super.dispose();
  }

  void _onRequestsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 800;
    final primaryColor = Color.fromARGB(255, 16, 134, 185);

    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Tasks & Requests",
              style: GoogleFonts.jetBrainsMono(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: isPhone
                ? IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  )
                : null,
            toolbarHeight: 80,
            backgroundColor: primaryColor,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, Color.fromARGB(255, 70, 229, 184)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          drawer: isPhone ? Drawer(child: Sidebar()) : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!isPhone) Sidebar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Tasks",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Complete your daily facility management tasks",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Daily Tasks List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dailyTasks.length,
                            itemBuilder: (context, index) {
                              final task = dailyTasks[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: task['done'] 
                                        ? Colors.green.withOpacity(0.3)
                                        : Color(0xFFE2E8F0),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: task['done']
                                          ? Colors.green.withOpacity(0.1)
                                          : primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      task['done'] 
                                          ? Icons.check_circle 
                                          : Icons.radio_button_unchecked,
                                      color: task['done'] 
                                          ? Colors.green 
                                          : primaryColor,
                                    ),
                                  ),
                                  title: Text(
                                    task['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: task['done']
                                          ? Color(0xFF94A3B8)
                                          : Color(0xFF1E293B),
                                      decoration: task['done']
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  subtitle: Text(
                                    task['time'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  trailing: !task['done']
                                      ? ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              dailyTasks[index]['done'] = true;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Task marked as done!'),
                                                duration: Duration(seconds: 2),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "Mark Done",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            "Completed",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          
                          SizedBox(height: 40),
                          
                          // Refill Requests Section
                          Text(
                            "Refill Requests",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Manage supply refill requests from the dashboard",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Refill Requests List
                          _requestsManager.refillRequests.isEmpty
                              ? Container(
                                  padding: EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 48,
                                          color: Color(0xFF94A3B8),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "No refill requests yet",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _requestsManager.refillRequests.length,
                                  itemBuilder: (context, index) {
                                    final request = _requestsManager.refillRequests[index];
                                    final isPending = request['status'] == 'Pending';
                                    
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFFE2E8F0),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: request['type'] == 'Water Supply'
                                                ? Colors.blue.withOpacity(0.1)
                                                : Colors.purple.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            request['type'] == 'Water Supply'
                                                ? Icons.water_drop
                                                : Icons.soap,
                                            color: request['type'] == 'Water Supply'
                                                ? Colors.blue
                                                : Colors.purple,
                                          ),
                                        ),
                                        title: Text(
                                          request['type'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Requested at ${request['time']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isPending
                                                ? Color(0xFFF59E0B).withOpacity(0.1)
                                                : primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            request['status'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isPending
                                                  ? Color(0xFFF59E0B)
                                                  : primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}