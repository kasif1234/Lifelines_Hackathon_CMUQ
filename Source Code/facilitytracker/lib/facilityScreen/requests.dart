import 'package:facilitytracker/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 800;
    final primaryColor = Color.fromARGB(255, 16, 134, 185);

    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Requests",
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
                  child: Center(
                    child: Text(
                      "Requests",
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
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