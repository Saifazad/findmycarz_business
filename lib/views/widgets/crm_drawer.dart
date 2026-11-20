import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../dashboard/admin_dashboard_screen.dart';
import '../dashboard/partner_dashboard_screen.dart';
import '../administrators/administrators_screen.dart';
import '../cars/cars_screen.dart';
import '../cars/my_inventory_screen.dart';
import '../cars/owner_listed_cars_screen.dart';
import '../leads/leads_list_screen.dart';
import '../leads/insurance_leads_screen.dart';
import '../contact/contact_screen.dart';
import '../content_management/blogs_screen.dart';
import '../content_management/testimonials_screen.dart';
import '../content_management/car_loans_screen.dart';
import '../content_management/flash_news_screen.dart';
import '../user_management/users_screen.dart';
import '../user_management/crm_role_hierarchy_screen.dart';
import '../auth/login_screen.dart';

class CrmDrawer extends StatelessWidget {
  const CrmDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003366), Color(0xFF0055AA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  authVM.userName != null && authVM.userName!.isNotEmpty
                      ? authVM.userName![0].toUpperCase()
                      : "A",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF003366),
                  ),
                ),
              ),
              accountName: Text(
                authVM.userName ?? "Find My Carz User",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(
                authVM.isSuperAdmin ? "Super Admin" : "Partner Associate",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                    child: Text(
                      "-- DASHBOARD OVERVIEW",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Dashboard",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      if (authVM.isSuperAdmin) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminDashboardScreen()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PartnerDashboardScreen()),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings,
                        color: Color(0xFF003366)),
                    title: Text("Administrators",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdministratorsScreen()),
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                    child: Text(
                      "-- CAR MANAGEMENT",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_car_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Cars",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.warehouse_outlined,
                        color: Color(0xFF003366)),
                    title: Text("My Inventory",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyInventoryScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_car_filled_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Owner Listed Cars",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OwnerListedCarsScreen()),
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                    child: Text(
                      "-- LEADS MANAGEMENT",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_outline,
                        color: Color(0xFF003366)),
                    title: Text("Loan Leads",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LeadsListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Insurance Leads",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InsuranceLeadsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Contact",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ContactScreen()),
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                    child: Text(
                      "-- CONTENT MANAGEMENT",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.rss_feed, color: Color(0xFF003366)),
                    title: Text("Blogs",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BlogsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline,
                        color: Color(0xFF003366)),
                    title: Text("Testimonials",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TestimonialsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_car_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Car Loans",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CarLoansScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.campaign_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Flash News & Marquee",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FlashNewsScreen()),
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                    child: Text(
                      "-- USER MANAGEMENT",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.groups_outlined,
                        color: Color(0xFF003366)),
                    title: Text("Users",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_tree_outlined,
                        color: Color(0xFF003366)),
                    title: Text("CRM Role Hierarchy",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CrmRoleHierarchyScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Logout
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text("Logout",
                  style: GoogleFonts.poppins(
                      color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: () async {
                await authVM.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
