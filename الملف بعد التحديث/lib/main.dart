// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/route_names.dart';
import 'modules/auth/screens/role_selection_screen.dart';
import 'modules/reception_app/screens/booking_screen.dart';
import 'modules/reception_app/screens/bookings_list_screen.dart';
import 'modules/reception_app/screens/filtered_bookings_screen.dart';
import 'modules/reception_app/screens/home_screen.dart';
import 'modules/reception_app/screens/room_details_screen.dart';
import 'modules/reception_app/screens/service_request_screen.dart';
import 'modules/reception_app/screens/booking_details_screen.dart';
import 'modules/admin_app/screens/admin_dashboard_screen.dart';
import 'modules/admin_app/screens/admin_service_requests_screen.dart';
import 'modules/admin_app/screens/bookings_report_screen.dart';
import 'modules/admin_app/screens/cleaning_requests_screen.dart';
import 'modules/admin_app/screens/missing_items_screen.dart';
import 'modules/cleaning_app/screens/cleaning_home_screen.dart';
import 'modules/cleaning_app/screens/cleaning_details_screen.dart';
import 'modules/guest/screens/guest_home_screen.dart';
import 'modules/guest/screens/guest_feedback_screen.dart';
import 'modules/guest/screens/guest_booking_lookup_screen.dart';
import 'modules/super_admin/screens/super_dashboard_screen.dart';
import 'modules/super_admin/screens/hotels_list_screen.dart';
import 'modules/super_admin/screens/hotel_details_screen.dart';
import 'modules/super_admin/screens/subscriptions_screen.dart';
import 'modules/super_admin/screens/payment_links_screen.dart';
import 'modules/super_admin/screens/super_admin_settings_screen.dart';
import 'modules/super_admin/screens/guest_feedback_report_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StayInHubApp());
}

class StayInHubApp extends StatelessWidget {
  const StayInHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayIn Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: RouteNames.roleSelection,
      routes: {
        // Auth
        RouteNames.roleSelection: (context) => const RoleSelectionScreen(),

        // Reception
        RouteNames.receptionHome: (context) => const HomeScreen(),
        RouteNames.booking: (context) => const BookingScreen(),
        RouteNames.bookingsList: (context) => const BookingsListScreen(),
        RouteNames.filteredBookings: (context) => const FilteredBookingsScreen(status: 'pending'),
        RouteNames.roomDetails: (context) => const RoomDetailsScreen(roomNumber: '101', roomStatus: 'available'),
        RouteNames.serviceRequest: (context) => const ServiceRequestScreen(),
        RouteNames.bookingDetails: (context) => BookingDetailsScreen(booking: BookingModel(
      id: '1',
      customerName: 'Test Customer',
      phoneNumber: '0555555555',
      roomNumber: '101',
      paymentMethod: 'cash',
      status: 'confirmed',
      checkInDate: DateTime.now(),
      checkOutDate: DateTime.now().add(Duration(days: 2)),
    )),

        // Admin
        RouteNames.adminDashboard: (context) => const AdminDashboardScreen(),
        RouteNames.adminServiceRequests: (context) => const AdminServiceRequestsScreen(),
        RouteNames.bookingsReport: (context) => const BookingsReportScreen(),
        RouteNames.cleaningRequests: (context) => const CleaningRequestsScreen(),
        RouteNames.missingItems: (context) => const MissingItemsScreen(),

        // Cleaning
        RouteNames.cleaningHome: (context) => const CleaningHomeScreen(),
        RouteNames.cleaningDetails: (context) => const CleaningDetailsScreen(roomNumber: '101'),

        // Guest
        RouteNames.guestHome: (context) => const GuestHomeScreen(),
        RouteNames.guestFeedback: (context) => const GuestFeedbackScreen(),
        RouteNames.guestBookingLookup: (context) => const GuestBookingLookupScreen(),

        // Super Admin
        RouteNames.superAdminDashboard: (context) => const SuperDashboardScreen(),
        RouteNames.hotelsList: (context) => const HotelsListScreen(),
        RouteNames.hotelDetails: (context) => const HotelDetailsScreen(hotelId: 'hotel123'),
        RouteNames.subscriptions: (context) => const SubscriptionsScreen(),
        RouteNames.paymentLinks: (context) => const PaymentLinksScreen(),
        RouteNames.superAdminSettings: (context) => const SuperAdminSettingsScreen(),
        RouteNames.guestFeedbackReport: (context) => const GuestFeedbackReportScreen(),
      },
    );
  }
}
