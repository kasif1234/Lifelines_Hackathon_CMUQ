import 'package:facilitytracker/widgets/sidebar_admin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:facilitytracker/mcu/api.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  final Mcuapi _api = Mcuapi();
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      isLoading = true;
    });
    
    final fetchedRequests = await _api.getFacilityRequests();
    
    setState(() {
      requests = fetchedRequests;
      isLoading = false;
    });
  }

  void _showRequestDialog(Map<String, dynamic> request, int index) {
    final primaryColor = Color.fromARGB(255, 16, 134, 185);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                request['type'] == 'Water Supply' ? Icons.water_drop : Icons.soap,
                color: primaryColor,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Request Details',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Facility', request['facility'] ?? 'Unknown'),
              _buildDetailRow('Type', request['type'] ?? 'Unknown'),
              _buildDetailRow('Time', request['time'] ?? 'N/A'),
              _buildDetailRow('Status', request['status'] ?? 'Pending'),
              if (request['message'] != null)
                _buildDetailRow('Message', request['message']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectRequest(index);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Reject',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _acceptRequest(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Accept',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptRequest(int index) {
    setState(() {
      requests.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request accepted!',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _rejectRequest(int index) {
    setState(() {
      requests.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request rejected',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 800;
    final isTablet = screenWidth >= 800 && screenWidth < 1200;
    final primaryColor = Color.fromARGB(255, 16, 134, 185);
    final cardBg = Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Facility Requests",
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadRequests,
          ),
        ],
      ),
      drawer: isPhone ? Drawer(child: SidebarAdmin()) : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!isPhone) SidebarAdmin(),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Facility Requests",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "View and manage requests from all facilities",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: 24),
                            
                            // Requests grid
                            requests.isEmpty
                                ? Container(
                                    padding: EdgeInsets.all(48),
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
                                            size: 64,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            "No requests from facilities",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "All facilities are operating normally",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(20),
                                    itemCount: requests.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isPhone ? 1 : (isTablet ? 2 : 3),
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 1.3,
                                    ),
                                    itemBuilder: (context, index) {
                                      final request = requests[index];
                                      final isPending = request['status'] == 'Pending';
                                      
                                      return GestureDetector(
                                        onTap: () => _showRequestDialog(request, index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: cardBg,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Color(0xFFE2E8F0),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryColor.withOpacity(0.1),
                                                blurRadius: 20,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 64,
                                                height: 64,
                                                decoration: BoxDecoration(
                                                  color: request['type'] == 'Water Supply'
                                                      ? Colors.blue.withOpacity(0.1)
                                                      : Colors.purple.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  request['type'] == 'Water Supply'
                                                      ? Icons.water_drop
                                                      : Icons.soap,
                                                  color: request['type'] == 'Water Supply'
                                                      ? Colors.blue
                                                      : Colors.purple,
                                                  size: 32,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                request['facility'] ?? 'Unknown Facility',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1E293B),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                request['type'] ?? 'Unknown',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Color(0xFF64748B),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 12),
                                              Container(
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
                                                  request['status'] ?? 'Pending',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: isPending
                                                        ? Color(0xFFF59E0B)
                                                        : primaryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                request['time'] ?? 'N/A',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Color(0xFF94A3B8),
                                                ),
                                              ),
                                            ],
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
