import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/admin_profile_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../widgets/custom_back_button.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Edit Profile Form Controllers
  final _editFormKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _dobController;
  String _selectedGender = "Male";

  // Change Password Form Controllers
  final _passwordFormKey = GlobalKey<FormState>();
  late TextEditingController _currentPassController;
  late TextEditingController _newPassController;
  late TextEditingController _confirmPassController;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _altPhoneController = TextEditingController();
    _dobController = TextEditingController();

    _currentPassController = TextEditingController();
    _newPassController = TextEditingController();
    _confirmPassController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _dobController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final profileVM = context.read<ProfileViewModel>();
    final authVM = context.read<AuthViewModel>();
    final success = await profileVM.fetchProfile();
    if (!mounted) return;
    if (success && profileVM.profile != null) {
      _populateEditForm(profileVM.profile!);
    } else {
      // Fallback with AuthViewModel data if any
      _nameController.text = authVM.userName ?? "";
      _phoneController.text = authVM.userPhone ?? "";
    }
  }

  String _formatDob(String? raw) {
    if (raw == null || raw.trim().isEmpty || raw == "null") {
      return "Not specified";
    }
    try {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy").format(parsed.toLocal());
      }
    } catch (_) {}
    if (raw.contains('T')) {
      return raw.split('T').first;
    }
    return raw;
  }

  void _populateEditForm(AdminProfileModel profile) {
    _nameController.text = profile.fullName ?? profile.username ?? "";
    _phoneController.text = profile.phone ?? "";
    _altPhoneController.text = profile.altPhone ?? "";
    
    if (profile.dob != null && profile.dob!.isNotEmpty && profile.dob != "null") {
      try {
        final parsed = DateTime.tryParse(profile.dob!);
        if (parsed != null) {
          final local = parsed.toLocal();
          _dobController.text =
              "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}";
        } else {
          _dobController.text = profile.dob!.contains('T')
              ? profile.dob!.split('T').first
              : profile.dob!;
        }
      } catch (_) {
        _dobController.text = profile.dob!;
      }
    } else {
      _dobController.text = "";
    }

    if (profile.gender != null &&
        (profile.gender == "Male" || profile.gender == "Female" || profile.gender == "Other")) {
      _selectedGender = profile.gender!;
    }
  }

  void _saveProfile() async {
    if (!_editFormKey.currentState!.validate()) return;

    final profileVM = context.read<ProfileViewModel>();
    final authVM = context.read<AuthViewModel>();

    final success = await profileVM.updateProfile(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      altPhone: _altPhoneController.text.trim(),
      gender: _selectedGender,
      dob: _dobController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Sync local AuthViewModel
      await authVM.updateLocalProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileVM.successMessage ?? "Profile updated successfully!",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileVM.errorMessage ?? "Failed to update profile.",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    final profileVM = context.read<ProfileViewModel>();

    final success = await profileVM.changePassword(
      currentPassword: _currentPassController.text,
      newPassword: _newPassController.text,
      newPasswordConfirmation: _confirmPassController.text,
    );

    if (!mounted) return;

    if (success) {
      _currentPassController.clear();
      _newPassController.clear();
      _confirmPassController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileVM.successMessage ?? "Password changed successfully!",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileVM.errorMessage ?? "Failed to change password.",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime(1995, 1, 1);
    if (_dobController.text.isNotEmpty) {
      try {
        final parsed = DateTime.tryParse(_dobController.text);
        if (parsed != null && parsed.isBefore(DateTime.now())) {
          initial = parsed;
        }
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003366),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final profile = profileVM.profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Admin Profile & Security",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        leading: const CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: "Refresh Profile",
            icon: const Icon(Icons.refresh, color: Color(0xFF003366)),
            onPressed: () {
              profileVM.fetchProfile().then((_) {
                if (profileVM.profile != null) {
                  _populateEditForm(profileVM.profile!);
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF003366),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF003366),
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.person_outline, size: 20), text: "Overview"),
            Tab(icon: Icon(Icons.edit_outlined, size: 20), text: "Edit Profile"),
            Tab(icon: Icon(Icons.lock_reset, size: 20), text: "Security"),
          ],
        ),
      ),
      body: profileVM.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF003366)),
            )
          : RefreshIndicator(
              color: const Color(0xFF003366),
              onRefresh: () async {
                await profileVM.fetchProfile();
                if (profileVM.profile != null) {
                  _populateEditForm(profileVM.profile!);
                }
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(profile, authVM),
                  _buildEditProfileTab(profileVM),
                  _buildSecurityTab(profileVM),
                ],
              ),
            ),
    );
  }

  // TAB 1: OVERVIEW & DETAILS
  Widget _buildOverviewTab(AdminProfileModel? profile, AuthViewModel authVM) {
    final displayName = profile?.fullName ?? authVM.userName ?? "Admin User";
    final email = profile?.email ?? authVM.userEmail ?? "admin@gmail.com";
    final phone = profile?.phone ?? authVM.userPhone ?? "Not specified";
    final roleName = profile?.role?.name ?? authVM.roleName ?? "Super Admin";
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : "A";
    final imageUrl = profile?.image ?? authVM.avatarUrl;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Profile Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003366), Color(0xFF0055AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003366).withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  backgroundImage: imageUrl != null && imageUrl.startsWith('http')
                      ? NetworkImage(imageUrl)
                      : null,
                  onBackgroundImageError: imageUrl != null && imageUrl.startsWith('http')
                      ? (_, __) {}
                      : null,
                  child: Text(
                    initial,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF003366),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          roleName,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Details List
          Text(
            "Account Information",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildInfoTile(
                    Icons.badge_outlined, "Username", profile?.username ?? "N/A"),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(
                    Icons.email_outlined, "Email Address", email),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(
                    Icons.phone_outlined, "Phone Number", phone),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(
                    Icons.phone_iphone, "Alt Phone", profile?.altPhone ?? "None"),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(
                    Icons.person_pin_outlined, "Gender", profile?.gender ?? "Not specified"),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(
                    Icons.cake_outlined, "Date of Birth", _formatDob(profile?.dob)),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(
                    Icons.security, "Role Code", profile?.role?.code ?? "SA"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Modules Access Suite
          if (profile != null && profile.modulesAccess.isNotEmpty) ...[
            Text(
              "Assigned Module Permissions",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: profile.modulesAccess.map((mod) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: Color(0xFF10B981)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Module #${mod.moduleId ?? 1}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 4,
                          children: [
                            if (mod.canView) _permissionChip("View", Colors.blue),
                            if (mod.canAdd) _permissionChip("Add", Colors.green),
                            if (mod.canEdit) _permissionChip("Edit", Colors.orange),
                            if (mod.canDelete) _permissionChip("Delete", Colors.red),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _permissionChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF003366)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: EDIT PROFILE FORM (POST /profile/update)
  Widget _buildEditProfileTab(ProfileViewModel profileVM) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _editFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Personal Details",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Edit your basic info below. All changes will be updated live on the server via multipart sync.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Full Name
                  Text(
                    "Full Name *",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      hint: "Enter your full name",
                      icon: Icons.person_outline,
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? "Full name is required" : null,
                  ),
                  const SizedBox(height: 14),

                  // Phone Number
                  Text(
                    "Phone Number *",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      hint: "Enter phone number",
                      icon: Icons.phone_outlined,
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? "Phone number is required" : null,
                  ),
                  const SizedBox(height: 14),

                  // Alternate Phone
                  Text(
                    "Alternate Phone",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _altPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      hint: "Enter alternate phone (optional)",
                      icon: Icons.phone_iphone,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Gender Selection
                  Text(
                    "Gender",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    decoration: _inputDecoration(
                      hint: "Select Gender",
                      icon: Icons.wc,
                    ),
                    items: ["Male", "Female", "Other"]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGender = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Date of Birth
                  Text(
                    "Date of Birth (YYYY-MM-DD)",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: _inputDecoration(
                      hint: "Select DOB",
                      icon: Icons.calendar_today_outlined,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Profile Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: profileVM.isUpdating ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                      ),
                      child: profileVM.isUpdating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Save Profile Changes",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: SECURITY / CHANGE PASSWORD (POST /profile/change-password)
  Widget _buildSecurityTab(ProfileViewModel profileVM) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: Color(0xFF003366), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Change Admin Password",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your new password must be at least 6 characters long and match confirmation.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Current Password
                  Text(
                    "Current Password *",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _currentPassController,
                    obscureText: _obscureCurrent,
                    decoration: _passwordInputDecoration(
                      hint: "Enter your existing password",
                      isObscured: _obscureCurrent,
                      onToggle: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? "Current password is required"
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // New Password
                  Text(
                    "New Password *",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _newPassController,
                    obscureText: _obscureNew,
                    decoration: _passwordInputDecoration(
                      hint: "Enter new password (min 6 chars)",
                      isObscured: _obscureNew,
                      onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "New password is required";
                      }
                      if (v.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Confirm New Password
                  Text(
                    "Confirm New Password *",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _confirmPassController,
                    obscureText: _obscureConfirm,
                    decoration: _passwordInputDecoration(
                      hint: "Re-enter new password",
                      isObscured: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Confirmation is required";
                      }
                      if (v != _newPassController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          profileVM.isChangingPassword ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                      ),
                      child: profileVM.isChangingPassword
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Update Password",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF003366), size: 20),
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

  InputDecoration _passwordInputDecoration({
    required String hint,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF003366), size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          isObscured ? Icons.visibility_off : Icons.visibility,
          color: const Color(0xFF64748B),
          size: 20,
        ),
        onPressed: onToggle,
      ),
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
}
