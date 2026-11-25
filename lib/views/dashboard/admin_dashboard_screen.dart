import 'package:findmycarz_business/views/cars/cars_screen.dart';
import 'package:findmycarz_business/views/cars/my_inventory_screen.dart';
import 'package:findmycarz_business/views/cars/owner_listed_cars_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/admin_dashboard_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/admin_profile_avatar.dart';
import '../widgets/stat_metric_card.dart';
import '../widgets/loan_pipeline_card.dart';
import '../leads/leads_list_screen.dart';
import '../leads/insurance_leads_screen.dart';
import '../contact/contact_screen.dart';
import '../cars/add_car_screen.dart';
import '../profile/admin_profile_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool get _isDarkMode => context.read<ThemeViewModel>().isDarkMode;
  String _selectedTimeFilter = "All Time (Overall)";
  final List<String> _timeFilterOptions = [
    "All Time (Overall)",
    "Today",
    "This Week",
    "This Month",
    "This Year",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminDashboardViewModel>().fetchDashboardStats();
    });
  }

  void _navigateToLeads(String initialType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeadsListScreen(initialType: initialType),
      ),
    );
  }

  void _navigateToInsurance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const InsuranceLeadsScreen(),
      ),
    );
  }

  void _navigateToContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ContactScreen(),
      ),
    );
  }

  void _showEnquiriesSupportSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enquiries & Support",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined,
                        color: Color(0xFF06B6D4), size: 20),
                  ),
                  title: Text(
                    "Insurance Leads (10)",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    "View all active insurance applications",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateToInsurance();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mail_outline_rounded,
                        color: Color(0xFF8B5CF6), size: 20),
                  ),
                  title: Text(
                    "Contact Enquiries (5)",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    "View general customer contact requests",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateToContacts();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required Color titleColor,
    required String count,
    required Color countColor,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color accentBarColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3.5,
                  color: accentBarColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(icon, size: 13, color: iconColor),
                        ),
                      ],
                    ),
                    Text(
                      count,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: countColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode
                            ? Colors.grey.shade300
                            : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeViewModel>();
    final dashVM = context.watch<AdminDashboardViewModel>();
    final stats = dashVM.data;
    final currentDate = DateFormat('EEEE, d MMM y').format(DateTime.now());

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu,
                color: _isDarkMode ? Colors.white : Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isDarkMode ? "Light Mode" : "Dark Mode",
            icon: Icon(
              _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
              color: _isDarkMode ? const Color(0xFFFBBF24) : Colors.black87,
            ),
            onPressed: () {
              context.read<ThemeViewModel>().toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              );
            },
            child: const AdminProfileAvatar(),
          ),
          const SizedBox(width: 14),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddCarScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF003366),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.add,
                              size: 16, color: Color(0xFF008844)),
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
                              MaterialPageRoute(
                                  builder: (_) => const LeadsListScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white60),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16),
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
                      const Icon(Icons.directions_car_filled_outlined,
                          size: 20, color: Color(0xFF008844)),
                      const SizedBox(width: 8),
                      Text(
                        "Car Management",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarsScreen()),
                      );
                    },
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
                        const Icon(Icons.arrow_forward,
                            size: 14, color: Color(0xFF008844)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Metric Cards Grid (Total Cars 901, Available 602, etc. - Color Palette matched to Image 1)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.48,
                children: [
                  StatMetricCard(
                    title: "TOTAL CARS",
                    count: "${stats.totalCars}",
                    icon: Icons.directions_car,
                    accentColor: const Color(0xFF2563EB),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF1E3A8A).withValues(alpha: 0.3)
                        : const Color(0xFFEFF6FF),
                    countColor: Colors.black87,
                    subtitle: "Full Fleet",
                    actionText: "Browse",
                    actionColor: const Color(0xFF10B981),
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarsScreen()),
                      );
                    },
                  ),
                  StatMetricCard(
                    title: "AVAILABLE",
                    count: "${stats.availableCars}",
                    icon: Icons.check_circle_outline,
                    accentColor: const Color(0xFF10B981),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                        : const Color(0xFFECFDF5),
                    countColor: const Color(0xFF10B981),
                    subtitle: "Ready for Sale",
                    subtitleColor: const Color(0xFF10B981),
                    actionText: "View",
                    actionColor: const Color(0xFF10B981),
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarsScreen()),
                      );
                    },
                  ),
                  StatMetricCard(
                    title: "SOLD CARS",
                    count: "${stats.soldCars}",
                    icon: Icons.sell_outlined,
                    accentColor: const Color(0xFFF97316),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF7C2D12).withValues(alpha: 0.3)
                        : const Color(0xFFFFF7ED),
                    countColor: const Color(0xFFF97316),
                    subtitle: "Closed Deals",
                    subtitleColor: const Color(0xFFF97316),
                    actionText: "View",
                    actionColor: const Color(0xFFF97316),
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarsScreen()),
                      );
                    },
                  ),
                  StatMetricCard(
                    title: "OWNER LISTED CARS",
                    count: "${stats.ownerListedCars}",
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFF8B5CF6),
                    accentColor: const Color(0xFF8B5CF6),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF2E1065)
                        : const Color(0xFFF5F3FF),
                    countColor: const Color(0xFF06B6D4),
                    subtitle: "Direct Owners",
                    actionText: "Manage",
                    actionColor: const Color(0xFF06B6D4),
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OwnerListedCarsScreen()),
                      );
                    },
                  ),
                  StatMetricCard(
                    title: "MY INVENTORY",
                    count: "${stats.myInventory}",
                    icon: Icons.warehouse_outlined,
                    accentColor: const Color(0xFF7C3AED),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF2E1065)
                        : const Color(0xFFF5F3FF),
                    countColor: const Color(0xFF7C3AED),
                    subtitle: "Stock Control",
                    actionText: "Inventory",
                    actionColor: const Color(0xFF7C3AED),
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyInventoryScreen()),
                      );
                    },
                  ),
                  StatMetricCard(
                    title: "BRANDS",
                    count: "${stats.totalBrands}",
                    icon: Icons.military_tech_outlined,
                    accentColor: const Color(0xFFEF4444),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF7F1D1D).withValues(alpha: 0.3)
                        : const Color(0xFFFEE2E2),
                    countColor: const Color(0xFFEF4444),
                    subtitle: "Manufacturers",
                    actionText: "View",
                    actionColor: const Color(0xFFEF4444),
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Loan Types — Files Logged In Section (Formatted as per Image 1 & 2)
              Row(
                children: [
                  const Icon(Icons.pie_chart_outline,
                      size: 20, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Text(
                    "Loan Types — Files Logged In",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // All Time (Overall) Dropdown Filter Button (Inline, compact font)
                    PopupMenuButton<String>(
                      initialValue: _selectedTimeFilter,
                      onSelected: (val) {
                        setState(() {
                          _selectedTimeFilter = val;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color:
                          _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      itemBuilder: (ctx) => _timeFilterOptions.map((opt) {
                        final isSelected = opt == _selectedTimeFilter;
                        return PopupMenuItem<String>(
                          value: opt,
                          child: Text(
                            opt,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : (_isDarkMode
                                      ? Colors.white
                                      : Colors.black87),
                            ),
                          ),
                        );
                      }).toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF2563EB),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB)
                                  .withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 14,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _selectedTimeFilter,
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: Color(0xFF2563EB),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Login Info Badge (Inline, compact font)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.radio_button_unchecked,
                            size: 11,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Login = Under Process / Sent to Bank",
                            style: GoogleFonts.poppins(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: _isDarkMode
                                  ? Colors.grey.shade300
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Loan Pipeline Cards (All 8 categories matching screenshot)
              LoanPipelineCard(
                title: "Used Car Loan",
                icon: Icons.directions_car,
                badgeColor: const Color(0xFF2563EB),
                stats: stats.usedCarLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("Used Car Loan"),
                onViewLoggedIn: () => _navigateToLeads("Used Car Loan"),
                onAllLeads: () => _navigateToLeads("Used Car Loan"),
              ),
              LoanPipelineCard(
                title: "New Car Loan",
                icon: Icons.electric_car,
                badgeColor: const Color(0xFF16A34A),
                stats: stats.newCarLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("New Car Loan"),
                onViewLoggedIn: () => _navigateToLeads("New Car Loan"),
                onAllLeads: () => _navigateToLeads("New Car Loan"),
              ),
              LoanPipelineCard(
                title: "BT & Top-Up Loan",
                icon: Icons.swap_horiz_rounded,
                badgeColor: const Color(0xFF9333EA),
                stats: stats.btTopupLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("BT & Top-Up Loan"),
                onViewLoggedIn: () => _navigateToLeads("BT & Top-Up Loan"),
                onAllLeads: () => _navigateToLeads("BT & Top-Up Loan"),
              ),
              LoanPipelineCard(
                title: "Car Loan Refinance",
                icon: Icons.published_with_changes,
                badgeColor: const Color(0xFFD97706),
                stats: stats.refinanceLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("Refinance"),
                onViewLoggedIn: () => _navigateToLeads("Refinance"),
                onAllLeads: () => _navigateToLeads("Refinance"),
              ),
              LoanPipelineCard(
                title: "Personal Loan",
                icon: Icons.person_outline_rounded,
                badgeColor: const Color(0xFF0284C7),
                stats: stats.personalLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("Personal Loan"),
                onViewLoggedIn: () => _navigateToLeads("Personal Loan"),
                onAllLeads: () => _navigateToLeads("Personal Loan"),
              ),
              LoanPipelineCard(
                title: "Business Loan",
                icon: Icons.business_center_outlined,
                badgeColor: const Color(0xFF4F46E5),
                stats: stats.businessLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("Business Loan"),
                onViewLoggedIn: () => _navigateToLeads("Business Loan"),
                onAllLeads: () => _navigateToLeads("Business Loan"),
              ),
              LoanPipelineCard(
                title: "Home Loan",
                icon: Icons.home_outlined,
                badgeColor: const Color(0xFFDB2777),
                stats: stats.homeLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("Home Loan"),
                onViewLoggedIn: () => _navigateToLeads("Home Loan"),
                onAllLeads: () => _navigateToLeads("Home Loan"),
              ),
              LoanPipelineCard(
                title: "Loan Against Property",
                icon: Icons.account_balance_outlined,
                badgeColor: const Color(0xFF0D9488),
                stats: stats.lapLoans,
                isDarkMode: _isDarkMode,
                onTap: () => _navigateToLeads("Loan Against Property"),
                onViewLoggedIn: () => _navigateToLeads("Loan Against Property"),
                onAllLeads: () => _navigateToLeads("Loan Against Property"),
              ),
              const SizedBox(height: 24),

              // 4. Leads Management Overview Section
              Row(
                children: [
                  const Icon(Icons.assignment_outlined,
                      size: 20, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Text(
                    "Leads Management Overview",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // All Loan Leads Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigateToLeads("All"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.format_list_bulleted_rounded,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              "All Loan Leads",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Insurance (10) Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _navigateToInsurance,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF083344)
                              : const Color(0xFFECFEFF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF06B6D4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shield_outlined,
                                size: 14, color: Color(0xFF06B6D4)),
                            const SizedBox(width: 5),
                            Text(
                              "Insurance (10)",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF06B6D4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Contacts (5) Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _navigateToContacts,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF2E1065)
                              : const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF8B5CF6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mail_outline_rounded,
                                size: 14, color: Color(0xFF8B5CF6)),
                            const SizedBox(width: 5),
                            Text(
                              "Contacts (5)",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Overview Cards 2x2 Grid (Compact Box Size)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.62,
                children: [
                  _buildOverviewCard(
                    title: "TOTAL LOAN LEADS",
                    titleColor: const Color(0xFF10B981),
                    count: "68",
                    countColor:
                        _isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    subtitle: "Across all loan products",
                    icon: Icons.folder_open_outlined,
                    iconColor: const Color(0xFF2563EB),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF1E3A8A).withValues(alpha: 0.3)
                        : const Color(0xFFEFF6FF),
                    accentBarColor: const Color(0xFF2563EB),
                    onTap: () => _navigateToLeads("All"),
                  ),
                  _buildOverviewCard(
                    title: "TOTAL FILES LOGGED IN",
                    titleColor: const Color(0xFF06B6D4),
                    count: "5",
                    countColor: const Color(0xFF06B6D4),
                    subtitle: "Active in bank processing",
                    icon: Icons.near_me_outlined,
                    iconColor: const Color(0xFF06B6D4),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF083344)
                        : const Color(0xFFECFEFF),
                    accentBarColor: const Color(0xFF06B6D4),
                    onTap: () => _navigateToLeads("All"),
                  ),
                  _buildOverviewCard(
                    title: "DISBURSED LEADS",
                    titleColor: const Color(0xFF10B981),
                    count: "11",
                    countColor: const Color(0xFF0D9488),
                    subtitle: "Disbursement completed",
                    icon: Icons.paid_outlined,
                    iconColor: const Color(0xFF10B981),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                        : const Color(0xFFF0FDF4),
                    accentBarColor: const Color(0xFF10B981),
                    onTap: () => _navigateToLeads("Disbursed"),
                  ),
                  _buildOverviewCard(
                    title: "ENQUIRIES & SUPPORT",
                    titleColor: const Color(0xFF6366F1),
                    count: "15",
                    countColor:
                        _isDarkMode ? Colors.white : const Color(0xFF1E293B),
                    subtitle: "10 Insurance • 5 Contact",
                    icon: Icons.headset_mic_outlined,
                    iconColor: const Color(0xFF10B981),
                    iconBgColor: _isDarkMode
                        ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                        : const Color(0xFFF0FDFA),
                    accentBarColor: const Color(0xFF6366F1),
                    onTap: _showEnquiriesSupportSheet,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
