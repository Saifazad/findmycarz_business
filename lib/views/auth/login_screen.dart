import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../dashboard/admin_dashboard_screen.dart';
import '../dashboard/partner_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController(text: 'awsdemoco');
  final TextEditingController _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;
  String _selectedRole = 'super_admin'; // 'super_admin' or 'partner'

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.login(
      emailOrPhone: _loginController.text.trim(),
      password: _passwordController.text.trim(),
      selectedRole: _selectedRole,
    );

    if (!mounted) return;

    if (success) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage ?? "Invalid credentials. Please try again."),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon / Logo
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF003366),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003366).withOpacity(0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.directions_car, size: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // Title & Subtitle
                  Text(
                    "Find My Carz",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF003366),
                    ),
                  ),
                  Text(
                    "BUSINESS & CRM PORTAL",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Role Switcher Tabs (Super Admin vs Partner)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedRole = 'super_admin';
                                _loginController.text = 'admin@findmycarz.com';
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'super_admin' ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedRole == 'super_admin'
                                    ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                    : null,
                              ),
                              child: Text(
                                "Super Admin",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: _selectedRole == 'super_admin' ? FontWeight.bold : FontWeight.w500,
                                  color: _selectedRole == 'super_admin' ? const Color(0xFF003366) : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedRole = 'partner';
                                _loginController.text = 'partner@findmycarz.com';
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'partner' ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedRole == 'partner'
                                    ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                    : null,
                              ),
                              child: Text(
                                "Administrator",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: _selectedRole == 'partner' ? FontWeight.bold : FontWeight.w500,
                                  color: _selectedRole == 'partner' ? const Color(0xFF003366) : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email or Mobile
                  TextFormField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: "Email or Staff ID",
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return "Please enter your username or email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return "Please enter your password";
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  if (authVM.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        authVM.errorMessage!,
                        style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Login Button
                  ElevatedButton(
                    onPressed: authVM.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: authVM.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(
                            "Login",
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "This application is strictly for authorized personnel and registered business partners of Find My Carz.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

