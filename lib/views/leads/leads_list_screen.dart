import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../../models/crm_lead_model.dart';

class LeadsListScreen extends StatefulWidget {
  final String? initialType;
  const LeadsListScreen({super.key, this.initialType});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeadsViewModel>().fetchLeads();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leadsVM = context.watch<LeadsViewModel>();
    final leads = leadsVM.filteredLeads;

    final filterTabs = ["All", "In Bank Login", "New", "Approved", "Disbursed"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          widget.initialType ?? "Leads & Loan Pipeline",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: filterTabs.length,
              itemBuilder: (ctx, i) {
                final tab = filterTabs[i];
                final isSelected = leadsVM.activeFilter == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(tab),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    selectedColor: const Color(0xFF003366),
                    backgroundColor: Colors.grey.shade100,
                    checkmarkColor: Colors.white,
                    onSelected: (_) => leadsVM.setFilter(tab),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Leads List
          Expanded(
            child: leadsVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : leads.isEmpty
                    ? Center(
                        child: Text(
                          "No leads found in this category",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: leads.length,
                        itemBuilder: (ctx, index) {
                          return _buildLeadCard(context, leads[index], leadsVM);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard(BuildContext context, CrmLeadModel lead, LeadsViewModel vm) {
    Color statusColor = Colors.blue;
    if (lead.status.contains('Bank')) statusColor = const Color(0xFF2563EB);
    if (lead.status.contains('Approved')) statusColor = const Color(0xFF16A34A);
    if (lead.status.contains('New')) statusColor = Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ID + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lead.id,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  lead.status,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Customer Name & Phone
          Text(
            lead.name,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            "${lead.phone} • ${lead.city ?? 'Location N/A'}",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),

          // Details row
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                    Text(lead.type, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                if (lead.amount != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Amount", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                      Text("₹ ${(lead.amount! / 100000).toStringAsFixed(2)} Lakhs",
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF003366))),
                    ],
                  ),
              ],
            ),
          ),
          if (lead.remarks != null && lead.remarks!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Note: ${lead.remarks}",
              style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
            ),
          ],
          const SizedBox(height: 12),

          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => vm.makePhoneCall(lead.phone),
                  icon: const Icon(Icons.call, size: 16, color: Color(0xFF16A34A)),
                  label: Text("Call", style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF16A34A), fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF16A34A)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => vm.openWhatsApp(lead.phone, lead.name),
                  icon: const Icon(Icons.chat, size: 16, color: Color(0xFF25D366)),
                  label: Text("WhatsApp", style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF25D366), fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF25D366)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showUpdateStatusSheet(context, lead, vm),
                icon: const Icon(Icons.edit_note, color: Color(0xFF003366)),
                tooltip: "Update Status",
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusSheet(BuildContext context, CrmLeadModel lead, LeadsViewModel vm) {
    String selectedStatus = lead.status;
    final remarksController = TextEditingController(text: lead.remarks ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Update Lead Status", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ["New", "In Bank Login", "Approved", "Disbursed", "Rejected"].map((s) {
                      return DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.poppins(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedStatus = val);
                    },
                    decoration: InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                      labelText: "Remarks / Notes",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await vm.updateLeadStatus(lead.id, selectedStatus, remarksController.text);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Save Update", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

