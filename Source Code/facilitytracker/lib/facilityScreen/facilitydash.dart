import 'package:facilitytracker/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:facilitytracker/mcu/api.dart';
import 'dart:async';


class FacilityDashScreen extends StatefulWidget {
  const FacilityDashScreen({super.key});

  @override
  State<FacilityDashScreen> createState() => _FacilityDashScreenState();
}

class _FacilityDashScreenState extends State<FacilityDashScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  final Mcuapi _api = Mcuapi();
  
  bool _isVideoInitialized = false;
  
  // State variables to hold live data
  double peoplePercentage = 0.0;
  double waterPercentage = 0.0;
  double soapPercentage = 0.0;
  double systemStatus = 0.0;
  
  // Stream subscriptions
  StreamSubscription<double>? _peopleSubscription;
  StreamSubscription<double>? _waterSubscription;
  StreamSubscription<double>? _soapSubscription;
  StreamSubscription<double>? _systemSubscription;

  @override
  void initState() {
    super.initState();
    
    // Initialize video controller
    
    _videoController = VideoPlayerController.asset('assets/POCDemo.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.play();
        _videoController.setLooping(true);
        _videoController.setVolume(0.0);
      }).catchError((error) {
        print('Video initialization error: $error');
      });
    
    // Subscribe to data streams
    _peopleSubscription = _api.getPeoplePercentageStream().listen((value) {
      setState(() {
        peoplePercentage = value;
      });
    });
    
    _waterSubscription = _api.getWaterPercentageStream().listen((value) {
      setState(() {
        waterPercentage = value;
      });
    });
    
    _soapSubscription = _api.getSoapPercentageStream().listen((value) {
      setState(() {
        soapPercentage = value;
      });
    });
    
    _systemSubscription = _api.getSystemStatusStream().listen((value) {
      setState(() {
        systemStatus = value;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _peopleSubscription?.cancel();
    _waterSubscription?.cancel();
    _soapSubscription?.cancel();
    _systemSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 800;
    final isTablet = screenWidth >= 800 && screenWidth < 1200;
  
    final primaryColor = Color.fromARGB(255, 16, 134, 185); // Emerald
    final warningColor = Color(0xFFF59E0B); // Amber
    final lowColor = Color(0xFFEF4444); // Red
    
    final cardBg = Colors.white;
    
    return Stack(
      children: [
        // Video Background
        if (_isVideoInitialized)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
        // Overlay to make content readable
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        // Main content
        Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Facility Dashboard", 
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
      body: SafeArea(
        child: Row(
          children: [
            if (!isPhone) Sidebar(),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 32),
                        child: Row(
                          children: [
                            Text(
                                              'Zone A - Facility 3',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Color(0xFF94A3B8),
                                              ),
                                            ),
                            SizedBox(width: 10),
                            
                          ],
                        ),
                        
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: GridView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isPhone ? 1 : (isTablet ? 2 :  4),
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 70,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final items = [
                                {
                                  'title': 'Population', 
                                  'icon': Icons.group, 
                                  'percentage': peoplePercentage,
                                },
                                {
                                  'title': 'Water Supply', 
                                  'icon': Icons.water_drop,
                                  'percentage': waterPercentage,
                                },
                                {
                                  'title': 'Soap Supply', 
                                  'icon': Icons.soap,
                                  'percentage': soapPercentage,
                                },
                                {
                                  'title': 'System Status', 
                                  'icon': Icons.dashboard,
                                  'percentage': systemStatus,
                                },
                                
                              ];
                              
                              
                              var title = items[index]['title'] as String;
                              var icon = items[index]['icon'] as IconData;
                              
                              
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: CircularProgressIndicator(
                                            value: items[index]['percentage'] as double,
                                            strokeWidth: 6,
                                            backgroundColor: primaryColor.withOpacity(0.1),
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              items[index]['title'] != "Population" ?  (items[index]['percentage'] as double) > 0.35
                                                  ? primaryColor
                                                  : ((items[index]['percentage'] as double) > 0.15 ? warningColor : lowColor): items[index]['percentage'] as double > 0.8 ? warningColor : items[index]['percentage'] as double > 0.9? lowColor: primaryColor,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          icon,
                                          size: 36,
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      title != "System Status" ? '${((items[index]['percentage'] as double) * 100).toInt()}%' : 'Perfect',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: items[index]['title'] != "Population" ?  (items[index]['percentage'] as double) > 0.35
                                            ? primaryColor
                                            : ((items[index]['percentage'] as double) > 0.15 ? warningColor : lowColor): items[index]['percentage'] as double > 0.8 ? warningColor : items[index]['percentage'] as double > 0.9? lowColor: primaryColor,
                                      ),
                                    ),
                                  SizedBox(height: 30),
                                  title == "Population"
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '45 people present',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF94A3B8)
                                            
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  title == "Water Supply" || title == "Soap Supply"
                                      ? TextButton(
                                        onPressed: (){
                                          // Show a notification saying it has been requested
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('$title refill requested!'),
                                              duration: Duration(seconds: 4),
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.green,
                                              
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).size.height - 150,
                                                right: 20,
                                                left: MediaQuery.of(context).size.width - 320,

                                              ),
                                            ),
                                          );



                                        }, 
                                        child: Text("Request Refill"),
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 170, 175, 76),
                                          foregroundColor: Colors.white,
                                          textStyle: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                      : SizedBox.shrink(),
                                  title== "System Status"
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'All sensors functional',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF94A3B8)
                                            
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  ],
                                ),
                              );
                            }
                          ),
                        ),
                       
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Restrooms Status',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              SizedBox(height: 20),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isPhone ? 1 : (isTablet ? 2 : 4),
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 2.2,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Icon(Icons.wc, color: primaryColor, size: 32),
                                        SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Restroom ${index + 1}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF374151),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Soap: Sufficient\nAction: Cleaned 1 hour ago',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Center(
                                              child: TextButton(
                                                onPressed: () {}, 
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  textStyle: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                child: Text("Mark as Cleaned"),
                                                
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}