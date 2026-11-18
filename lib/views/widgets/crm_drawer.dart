import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../dashboard/admin_dashboard_screen.dart';
import '../dashboard/partner_dashboard_screen.dart';
import '../payout/outward_payout_screen.dart';
import '../leads/leads_list_screen.dart';
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
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined, color: Color(0xFF003366)),
                    title: Text("Dashboard", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      if (authVM.isSuperAdmin) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const PartnerDashboardScreen()),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_outline, color: Color(0xFF003366)),
                    title: Text("Leads & Loans", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LeadsListScreen()),
                      );
                    },
                  ),
                  if (authVM.isSuperAdmin)
                    ListTile(
                      leading: const Icon(Icons.payments_outlined, color: Color(0xFF003366)),
                      title: Text("Outward Payouts", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OutwardPayoutScreen()),
                        );
                      },
                    ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.directions_car_outlined, color: Color(0xFF003366)),
                    title: Text("Inventory Fleet", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Logout
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text("Logout", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.w600)),
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

