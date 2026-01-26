import 'package:facilitytracker/adminScreen/admindash.dart';
import 'package:facilitytracker/adminScreen/adminlogin.dart';
import 'package:facilitytracker/adminScreen/adminrequests.dart';
import 'package:facilitytracker/facilityScreen/facilitydash.dart';
import 'package:facilitytracker/facilityScreen/requests.dart';
import 'package:facilitytracker/mcu/sensors.dart';
import 'package:go_router/go_router.dart';

class AppRouter{

  static final router = GoRouter(
    initialLocation: '/facility',
    routes: [
      GoRoute(
        path: "/adminlogin",
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: "/admin",
        builder: (context, state) => const AdminDashScreen(),
      ),
      GoRoute(
        path: "/adminrequests",
        builder: (context, state) => const AdminRequestsScreen(),
      ),
      GoRoute(
        path: "/facility",
        builder: (context, state) => const FacilityDashScreen(),
      ),
      GoRoute(
        path: "/sensors",
        builder: (context, state) => const SensorsDataScreen(),
      ),
      GoRoute(
        path: "/requests",
        builder: (context, state) => const RequestsScreen(),
      )
    ]
  );
}