import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/admin_dashboard_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/stat_metric_card.dart';
import '../widgets/loan_pipeline_card.dart';
import '../payout/outward_payout_screen.dart';
import '../leads/leads_list_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminDashboardViewModel>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashVM = context.watch<AdminDashboardViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final stats = dashVM.data;
    final currentDate = DateFormat('EEEE, d MMM y').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF003366),
            child: Text(
              authVM.userName?.isNotEmpty == true ? authVM.userName![0] : "A",
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const CrmDrawer(),
      body: RefreshIndicator(
        onRefresh: () => dashVM.fetchDashboardStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // 1. Blue Control Center Hero Card (Screenshot 1)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF003366), Color(0xFF0A4F9E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF003366).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Super Admin",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "• $currentDate",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Control Center & Management Dashboard",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Real-time vehicle inventory & loan applications tracker",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF003366),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 16, color: Color(0xFF008844)),
                        label: Text(
                          "Add Car",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LeadsListScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white60),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
                        label: Text(
                          "Loan Hub",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 2. Car Management Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_car_filled_outlined, size: 20, color: Color(0xFF008844)),
                    const SizedBox(width: 8),
                    Text(
                      "Car Management",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "View All Cars",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF008844),
                        ),
                      ),
                      const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF008844)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Metric Cards Grid (Total Cars 901, Available 602, etc.)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                StatMetricCard(
                  title: "TOTAL CARS",
                  count: "${stats.totalCars}",
                  icon: Icons.directions_car,
                  accentColor: const Color(0xFF2563EB),
                  countColor: Colors.black87,
                  subtitle: "Full Fleet",
                  actionText: "Browse",
                ),
                StatMetricCard(
                  title: "AVAILABLE",
                  count: "${stats.availableCars}",
                  icon: Icons.check_circle_outline,
                  accentColor: const Color(0xFF16A34A),
                  countColor: const Color(0xFF16A34A),
                  subtitle: "Ready for Sale",
                  actionText: "View",
                ),
                StatMetricCard(
                  title: "SOLD CARS",
                  count: "${stats.soldCars}",
                  icon: Icons.sell_outlined,
                  accentColor: const Color(0xFFEA580C),
                  countColor: const Color(0xFFEA580C),
                  subtitle: "Closed Deals",
                  actionText: "View",
                ),
                StatMetricCard(
                  title: "OWNER LISTED CARS",
                  count: "${stats.ownerListedCars}",
                  icon: Icons.person_outline,
                  accentColor: const Color(0xFF9333EA),
                  countColor: const Color(0xFF9333EA),
                  subtitle: "Direct Owners",
                  actionText: "Manage",
                ),
                StatMetricCard(
                  title: "MY INVENTORY",
                  count: "${stats.myInventory}",
                  icon: Icons.warehouse_outlined,
                  accentColor: const Color(0xFF003366),
                  countColor: const Color(0xFF003366),
                  subtitle: "Stock Control",
                  actionText: "Inventory",
                ),
                StatMetricCard(
                  title: "BRANDS",
                  count: "${stats.totalBrands}",
                  icon: Icons.verified_outlined,
                  accentColor: const Color(0xFFDC2626),
                  countColor: const Color(0xFFDC2626),
                  subtitle: "Manufacturers",
                  actionText: "View",
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Loan Types — Files Logged In Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.currency_rupee, size: 20, color: Color(0xFF16A34A)),
                    const SizedBox(width: 6),
                    Text(
                      "Loan Types — Files Logged In",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "○ Login = Under Process / Sent to Bank",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 14),

            // Loan Pipeline Cards
            LoanPipelineCard(
              title: "Used Car Loan",
              icon: Icons.directions_car,
              badgeColor: const Color(0xFF2563EB),
              stats: stats.usedCarLoans,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeadsListScreen(initialType: "Used Car Loan")),
                );
              },
            ),
            LoanPipelineCard(
              title: "New Car Loan",
              icon: Icons.electric_car,
              badgeColor: const Color(0xFF16A34A),
              stats: stats.newCarLoans,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeadsListScreen(initialType: "New Car Loan")),
                );
              },
            ),
            LoanPipelineCard(
              title: "BT & Top-Up Loan",
              icon: Icons.sync_alt,
              badgeColor: const Color(0xFF9333EA),
              stats: stats.btTopupLoans,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeadsListScreen(initialType: "BT & Top-Up Loan")),
                );
              },
            ),
            LoanPipelineCard(
              title: "Car Loan Refinance",
              icon: Icons.published_with_changes,
              badgeColor: const Color(0xFFD97706),
              stats: stats.refinanceLoans,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeadsListScreen(initialType: "Refinance")),
                );
              },
            ),
            const SizedBox(height: 20),

            // Shortcut to Outward Payout (Screenshot 2)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OutwardPayoutScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16A34A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.monetization_on_outlined, color: Color(0xFF16A34A)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Outward Payouts",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "View disbursed dealer payouts & commissions",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
