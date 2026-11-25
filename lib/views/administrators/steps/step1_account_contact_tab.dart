import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/administrator_meta_model.dart';
import '../../../models/administrator_model.dart';
import '../components/admin_card_wrapper.dart';

class Step1AccountContactTab extends StatelessWidget {
  final String? profilePhotoPath;
  final VoidCallback onUploadPhotoTap;

  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onGeneratePassword;

  final TextEditingController phoneController;
  final TextEditingController altPhoneController;
  final TextEditingController dobController;
  final VoidCallback onPickDate;

  final String selectedGender;
  final void Function(String gender) onGenderChanged;

  final TextEditingController jobLocationController;

  final AdministratorItem? selectedParent;
  final List<AdministratorItem> potentialManagers;
  final List<AdministratorItem> allAdmins;
  final void Function(AdministratorItem? parent) onParentChanged;

  final MetaRoleOption? selectedRole;
  final VoidCallback onRoleFieldTap;

  final TextEditingController maxLeadsController;
  final bool isActive;
  final void Function(bool active) onStatusChanged;

  const Step1AccountContactTab({
    super.key,
    this.profilePhotoPath,
    required this.onUploadPhotoTap,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onGeneratePassword,
    required this.phoneController,
    required this.altPhoneController,
    required this.dobController,
    required this.onPickDate,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.jobLocationController,
    required this.selectedParent,
    required this.potentialManagers,
    required this.allAdmins,
    required this.onParentChanged,
    required this.selectedRole,
    required this.onRoleFieldTap,
    required this.maxLeadsController,
    required this.isActive,
    required this.onStatusChanged,
  });

  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF003366), size: 18),
      suffixIcon: suffixIcon,
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
    final List<AdministratorItem> parentList = [];
    if (selectedParent != null) {
      parentList.add(selectedParent!);
    }
    for (final a in (allAdmins.isNotEmpty ? allAdmins : potentialManagers)) {
      if (!parentList.any((p) => p.id == a.id)) {
        parentList.add(a);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Picker
          Center(
            child: Column(
              children: [
                InkWell(
                  onTap: onUploadPhotoTap,
                  borderRadius: BorderRadius.circular(45),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF003366), width: 1.5),
                    ),
                    child: profilePhotoPath != null
                        ? ClipOval(
                            child: Image.asset(profilePhotoPath!,
                                fit: BoxFit.cover),
                          )
                        : const Icon(Icons.add_a_photo_outlined,
                            size: 30, color: Color(0xFF003366)),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: onUploadPhotoTap,
                  child: Text(
                    profilePhotoPath != null
                        ? "Change Photo"
                        : "+ Upload Photo",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0055AA)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account & Contact Card
          AdminCardWrapper(
            title: "Account & Contact",
            subtitle: "Personal information & login credentials",
            children: [
              _buildFieldLabel("Full Name *"),
              TextFormField(
                controller: nameController,
                decoration:
                    _inputDecoration("Enter full name", Icons.person_outline),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Username *"),
              TextFormField(
                controller: usernameController,
                decoration:
                    _inputDecoration("Enter username", Icons.alternate_email),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Email Address *"),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    _inputDecoration("Enter email", Icons.email_outlined),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFieldLabel("Password *"),
                  InkWell(
                    onTap: onGeneratePassword,
                    child: Row(
                      children: [
                        const Icon(Icons.bolt,
                            size: 14, color: Color(0xFF003366)),
                        Text(
                          "Auto Generate",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF003366),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: _inputDecoration(
                  "Enter password",
                  Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18),
                    onPressed: onTogglePassword,
                  ),
                ),
              ),
              if (passwordController.text.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: passwordController.text.length > 8
                              ? const Color(0xFF10B981)
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      passwordController.text.length > 8
                          ? "Strong Security"
                          : "Medium",
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),

              _buildFieldLabel("Phone *"),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration:
                    _inputDecoration("Enter phone", Icons.phone_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Alternate Number"),
              TextFormField(
                controller: altPhoneController,
                keyboardType: TextInputType.phone,
                decoration:
                    _inputDecoration("Enter alt phone", Icons.phone_iphone),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Date of Birth (dd/mm/yyyy)"),
              TextFormField(
                controller: dobController,
                readOnly: true,
                onTap: onPickDate,
                decoration: _inputDecoration(
                    "dd/mm/yyyy", Icons.calendar_today_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Gender *"),
              Row(
                children: ["Male", "Female", "Other"].map((g) {
                  final isSel = selectedGender == g;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => onGenderChanged(g),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFF003366)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            g,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight:
                                  isSel ? FontWeight.bold : FontWeight.w500,
                              color: isSel
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Job Location"),
              TextFormField(
                controller: jobLocationController,
                decoration: _inputDecoration("Select or type job location",
                    Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Parent Administrator (Reporting Manager)"),
              DropdownButtonFormField<int?>(
                initialValue: selectedParent?.id,
                isExpanded: true,
                decoration: _inputDecoration(
                    "Select Parent", Icons.account_tree_outlined),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text("Select Parent",
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ),
                  ...parentList.map((a) {
                    final isPotential =
                        potentialManagers.any((p) => p.id == a.id);
                    return DropdownMenuItem<int?>(
                      value: a.id,
                      child: Text(
                        "${a.fullName} (${a.role?.code ?? 'Staff'})${isPotential ? ' ⭐' : ''}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }),
                ],
                onChanged: (val) {
                  if (val == null) {
                    onParentChanged(null);
                  } else {
                    try {
                      final found = parentList.firstWhere((p) => p.id == val);
                      onParentChanged(found);
                    } catch (_) {
                      onParentChanged(null);
                    }
                  }
                },
              ),
              const SizedBox(height: 5),

              if (selectedRole != null)
                Row(
                  children: [
                    Icon(
                      potentialManagers.isNotEmpty
                          ? Icons.verified_user_outlined
                          : Icons.info_outline,
                      size: 13,
                      color: potentialManagers.isNotEmpty
                          ? const Color(0xFF10B981)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${potentialManagers.length} potential manager${potentialManagers.length == 1 ? '' : 's'} found for this role.",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: potentialManagers.isNotEmpty
                            ? const Color(0xFF10B981)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  "Select a Role first to filter potential managers",
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: const Color(0xFF94A3B8)),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Role / Type & Publishing Controls Card
          AdminCardWrapper(
            title: "Role / Type & Publishing",
            subtitle: "Designation, status and lead count limits",
            children: [
              _buildFieldLabel("Role / Type *"),
              InkWell(
                onTap: onRoleFieldTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          size: 18, color: Color(0xFF003366)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedRole != null
                              ? "${selectedRole!.name} (${selectedRole!.code})"
                              : "Search & Select Role...",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: selectedRole != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: selectedRole != null
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _buildFieldLabel("Max Leads Count"),
              TextFormField(
                controller: maxLeadsController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                    "e.g. 50 (blank = unlimited)", Icons.visibility_outlined),
              ),
              const SizedBox(height: 4),
              Text(
                "Maximum leads this member can view in lead lists. Leave empty for unlimited.",
                style: GoogleFonts.poppins(
                    fontSize: 10, color: const Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${isActive ? 'Active' : 'Inactive'}",
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(
                          isActive
                              ? "User can sign in & operate"
                              : "Access is temporarily blocked",
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: isActive
                                  ? const Color(0xFF10B981)
                                  : Colors.redAccent)),
                    ],
                  ),
                  Switch(
                    value: isActive,
                    activeThumbColor: const Color(0xFF10B981),
                    onChanged: onStatusChanged,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
