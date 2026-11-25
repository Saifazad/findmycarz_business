import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/payout_viewmodel.dart';
import '../widgets/crm_drawer.dart';

class OutwardPayoutScreen extends StatefulWidget {
  const OutwardPayoutScreen({super.key});

  @override
  State<OutwardPayoutScreen> createState() => _OutwardPayoutScreenState();
}

class _OutwardPayoutScreenState extends State<OutwardPayoutScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PayoutViewModel>().fetchPayouts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payoutVM = context.watch<PayoutViewModel>();
    final summary = payoutVM.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Outward Payout",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: const CrmDrawer(),
      body: RefreshIndicator(
        onRefresh: () => payoutVM.fetchPayouts(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "FIND MY CARZ • PAYOUT MANAGEMENT",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E7D32),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 4 Stat Cards in 2x2 Grid (Screenshot 2)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
                children: [
                  _buildPayoutMetric(
                    title: "DISBURSED LEADS",
                    value: "${summary.disbursedLeads}",
                    subtitle: "Verified disbursed cases",
                    icon: Icons.check_circle_outline,
                    accentColor: const Color(0xFF16A34A),
                  ),
                  _buildPayoutMetric(
                    title: "DISBURSED VOLUME",
                    value: "₹ ${summary.disbursedVolume.toStringAsFixed(2)}",
                    subtitle: "Total loan volume",
                    icon: Icons.account_balance_wallet_outlined,
                    accentColor: const Color(0xFF2563EB),
                  ),
                  _buildPayoutMetric(
                    title: "TOTAL OUTWARD PAYOUT",
                    value: "₹ ${summary.totalOutwardPayout.toStringAsFixed(2)}",
                    subtitle: "Commissions payable",
                    icon: Icons.monetization_on_outlined,
                    accentColor: const Color(0xFF0D9488),
                  ),
                  _buildPayoutMetric(
                    title: "AVG PAYOUT RATE",
                    value: "${summary.avgPayoutRate.toStringAsFixed(3)}%",
                    subtitle: "Average commission",
                    icon: Icons.percent,
                    accentColor: const Color(0xFFEA580C),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filters Container (Screenshot 2)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter Outward List",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Search input
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Customer, Phone, Lead ID...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF003366),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  payoutVM.setSearchQuery("");
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF003366),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (val) => payoutVM.setSearchQuery(val),
                    ),
                    const SizedBox(height: 10),

                    // Product / Loan Type Dropdown
                    DropdownButtonFormField<String>(
                      value: payoutVM.selectedLoanType,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      items: payoutVM.loanTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type, style: GoogleFonts.poppins(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) payoutVM.setSelectedLoanType(val);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Bank Dropdown
                    DropdownButtonFormField<String>(
                      value: payoutVM.selectedBank,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      items: payoutVM.banks.map((bank) {
                        return DropdownMenuItem(
                          value: bank,
                          child: Text(bank, style: GoogleFonts.poppins(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) payoutVM.setSelectedBank(val);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Filter & Reset buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => payoutVM.fetchPayouts(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.filter_alt_outlined, size: 16),
                            label: Text("Filter", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            _searchController.clear();
                            payoutVM.resetFilters();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          child: const Icon(Icons.refresh, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Items List or Empty State (Screenshot 2)
              if (summary.items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        "No Outward Payout Records",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "No verified disbursed cases found for the selected filter.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: summary.items.length,
                  itemBuilder: (ctx, index) {
                    final item = summary.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.customerName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text("Dealer: ${item.dealerName}", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600)),
                              Text(item.loanType, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF003366))),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("₹${item.payoutAmount.toStringAsFixed(2)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF16A34A))),
                              Text(item.status, style: GoogleFonts.poppins(fontSize: 11, color: Colors.orange)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayoutMetric({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Icon(icon, size: 16, color: accentColor),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
