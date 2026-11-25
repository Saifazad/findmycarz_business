import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/administrator_meta_model.dart';
import '../components/admin_card_wrapper.dart';

class Step2BankAddressTab extends StatelessWidget {
  final TextEditingController ifscController;
  final bool ifscVerified;
  final void Function(String ifsc) onIfscChanged;
  final TextEditingController bankNameController;
  final TextEditingController branchController;
  final TextEditingController accountNumberController;

  final TextEditingController pincodeController;
  final void Function(String pincode) onPincodeChanged;
  final List<MetaStateOption> states;
  final MetaStateOption? selectedState;
  final void Function(MetaStateOption? state) onStateChanged;
  final TextEditingController cityController;
  final TextEditingController addressController;

  const Step2BankAddressTab({
    super.key,
    required this.ifscController,
    required this.ifscVerified,
    required this.onIfscChanged,
    required this.bankNameController,
    required this.branchController,
    required this.accountNumberController,
    required this.pincodeController,
    required this.onPincodeChanged,
    required this.states,
    required this.selectedState,
    required this.onStateChanged,
    required this.cityController,
    required this.addressController,
  });

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF003366), size: 18),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bank Details
          AdminCardWrapper(
            title: "Bank Details",
            subtitle: "Commission and disbursement bank account info",
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFieldLabel("IFSC Code"),
                  if (ifscVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 12, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text(
                            "Verified",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              TextFormField(
                controller: ifscController,
                textCapitalization: TextCapitalization.characters,
                onChanged: onIfscChanged,
                decoration: _inputDecoration("E.G. SBIN0001234", Icons.tag),
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("Bank Name"),
              TextFormField(
                controller: bankNameController,
                decoration: _inputDecoration(
                    "Bank Name", Icons.account_balance_outlined),
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("Branch Name"),
              TextFormField(
                controller: branchController,
                decoration: _inputDecoration(
                    "Branch Name", Icons.store_mall_directory_outlined),
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("Account Number"),
              TextFormField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Account Number", Icons.numbers),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Address Details
          AdminCardWrapper(
            title: "Address Details",
            subtitle: "State, city and street address",
            children: [
              _buildFieldLabel("Pincode"),
              TextFormField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                onChanged: onPincodeChanged,
                decoration:
                    _inputDecoration("e.g. 110001", Icons.pin_drop_outlined),
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("State"),
              DropdownButtonFormField<int?>(
                initialValue: (selectedState != null &&
                        states.any((s) => s.id == selectedState!.id))
                    ? selectedState!.id
                    : null,
                isExpanded: true,
                decoration:
                    _inputDecoration("Select State", Icons.map_outlined),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text("Select State",
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ),
                  ...states.map((s) {
                    return DropdownMenuItem<int?>(
                      value: s.id,
                      child: Text(s.stateName,
                          overflow: TextOverflow.ellipsis, maxLines: 1),
                    );
                  }),
                ],
                onChanged: (val) {
                  if (val == null) {
                    onStateChanged(null);
                  } else {
                    try {
                      final found = states.firstWhere((s) => s.id == val);
                      onStateChanged(found);
                    } catch (_) {
                      onStateChanged(null);
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("City / District"),
              TextFormField(
                controller: cityController,
                decoration: _inputDecoration(
                    "Select or type City", Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("Full Address"),
              TextFormField(
                controller: addressController,
                maxLines: 2,
                decoration:
                    _inputDecoration("Enter full address", Icons.home_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
