import 'package:facilitytracker/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    final passwordController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 800;
    final primaryColor = Color.fromARGB(255, 16, 134, 185);
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "NGO Portal", 
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
              colors: [const Color.fromARGB(255, 237, 189, 126), Color.fromARGB(255, 229, 221, 70)],
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
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Please fill in your admin credentials to login',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 24, 
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 50),
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          
                          if (userNameController.text == 'admin' && passwordController.text == 'admin123') {
                            context.go('/admin');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color.fromARGB(255, 233, 119, 119),
                                content: Text('Invalid credentials. Please try again.',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 120),
                                ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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