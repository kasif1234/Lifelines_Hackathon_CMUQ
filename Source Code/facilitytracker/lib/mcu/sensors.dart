import 'package:facilitytracker/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SensorsDataScreen extends StatelessWidget {
  const SensorsDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 800;
    final primaryColor = Color.fromARGB(255, 16, 134, 185);
    final isTablet = screenWidth >= 800 && screenWidth < 1200;
    final cardBg = Colors.white;

    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Sensors Status",
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
                          padding: const EdgeInsets.all(28.0),
                          child: GridView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isPhone ? 1 : (isTablet ? 2 :  4),
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 30,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              final items = [
                                {
                                  'title': 'Population Sensor',
                                  'icon': Icons.people, 
                                  'status': 'Active',
                                  'isMultiRoom': false,
                                },
                                {
                                  'title': 'Water Tank Sensor', 
                                  'icon': Icons.water_drop,
                                  'status': 'Active',
                                  'isMultiRoom': false,
                                },
                                {
                                  'title': 'Soap Supply Sensor', 
                                  'icon': Icons.soap,
                                  'status': 'Active',
                                  'isMultiRoom': false,
                                },
                                {
                                  'title': 'Toilet Access Sensors', 
                                  'icon': Icons.wc,
                                  'status': 'Active',
                                  'isMultiRoom': true,
                                  'rooms': [
                                    {'name': 'Restroom 1', 'status': 'Active'},
                                    {'name': 'Restroom 2', 'status': 'Active'},
                                    {'name': 'Restroom 3', 'status': 'Inactive'},
                                    {'name': 'Restroom 4', 'status': 'Active'},
                                  ],
                                },
                               
                                
                              ];
                              
                              var title = items[index]['title'] as String;
                              var icon = items[index]['icon'] as IconData;
                              var status = items[index]['status'] as String;
                              var isMultiRoom = items[index]['isMultiRoom'] as bool;
                              
                              final activeColor = Color.fromARGB(255, 16, 134, 185);
                              final inactiveColor = Color(0xFFEF4444);
                              
                              return Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 8),
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: status == 'Active' 
                                            ? activeColor.withOpacity(0.1)
                                            : inactiveColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        icon,
                                        size: 36,
                                        color: status == 'Active' ? activeColor : inactiveColor,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    
                                    
                                    if (!isMultiRoom) ...[
                                      
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: status == 'Active' 
                                              ? activeColor.withOpacity(0.1)
                                              : inactiveColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          status,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: status == 'Active' ? activeColor : inactiveColor,
                                          ),
                                        ),
                                      ),
                                    ] else ...[

                                      SizedBox(height: 8),
                                      Column(
                                        children: (items[index]['rooms'] as List<Map<String, String>>).map((room) {
                                          final roomStatus = room['status']!;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    room['name']!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Color(0xFF64748B),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: roomStatus == 'Active' 
                                                        ? activeColor
                                                        : inactiveColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  roomStatus,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: roomStatus == 'Active' 
                                                        ? activeColor
                                                        : inactiveColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                    
                                  ],
                                ),
                              );
                            }
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