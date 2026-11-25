import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/administrator_meta_model.dart';

class Step4PayoutMatrixTab extends StatelessWidget {
  final List<MetaBankOption> banks;
  final List<MetaCategoryOption> categories;
  final Map<int, Map<String, TextEditingController>> payoutControllers;
  final VoidCallback onApplyStandardRates;

  const Step4PayoutMatrixTab({
    super.key,
    required this.banks,
    required this.categories,
    required this.payoutControllers,
    required this.onApplyStandardRates,
  });

  @override
  Widget build(BuildContext context) {
    if (banks.isEmpty || categories.isEmpty) {
      return Center(
        child: Text("Loading payout banks & categories...",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⚡ 1-Tap Quick Apply Standard Rates Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFF2563EB), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1-Tap Standard FMC Rates",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E40AF))),
                      Text(
                          "Fills 1.5% Used Car, 0.75% New Car across all banks",
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: const Color(0xFF3B82F6))),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onApplyStandardRates,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text("Apply All",
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            "Bank Outward Payout Rates",
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            "Configure bank commission percentages (%) for this administrator across all loan categories.",
            style: GoogleFonts.poppins(
                fontSize: 11, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),

          ...banks.map((bank) {
            payoutControllers.putIfAbsent(bank.id, () => {});
            final bMap = payoutControllers[bank.id]!;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ExpansionTile(
                initiallyExpanded: bank == banks.first,
                leading: const Icon(Icons.account_balance,
                    color: Color(0xFF003366), size: 20),
                title: Text(bank.name,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text("Configure rates (%)",
                    style:
                        GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  ...categories.map((cat) {
                    bMap.putIfAbsent(
                        cat.code, () => TextEditingController(text: "0.00"));
                    final ctrl = bMap[cat.code]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(cat.name,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: ctrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  suffixText: "%",
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1))),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
