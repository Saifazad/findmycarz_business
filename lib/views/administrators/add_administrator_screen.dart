import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/administrator_meta_model.dart';
import '../../models/administrator_model.dart';
import '../../models/crm_role_model.dart';
import '../../viewmodels/administrators_viewmodel.dart';

// Modularized Components, Modals & Steps
import 'components/admin_bottom_bar.dart';
import 'components/admin_mini_profile_header.dart';
import 'components/admin_stepper_header.dart';
import 'components/live_staff_badge.dart';
import 'modals/role_picker_modal.dart';
import 'modals/upload_source_modal.dart';
import 'steps/step1_account_contact_tab.dart';
import 'steps/step2_bank_address_tab.dart';
import 'steps/step3_documents_tab.dart';
import 'steps/step4_payout_matrix_tab.dart';
import 'steps/step5_modular_access_tab.dart';

class AddAdministratorScreen extends StatefulWidget {
  final AdministratorItem? initialAdmin;
  const AddAdministratorScreen({super.key, this.initialAdmin});

  @override
  State<AddAdministratorScreen> createState() => _AddAdministratorScreenState();
}

class _AddAdministratorScreenState extends State<AddAdministratorScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // 1. Account & Contact Controllers
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _jobLocationController = TextEditingController();
  String _selectedGender = "Male";
  bool _obscurePassword = true;

  // Role, Hierarchy & Limit
  MetaRoleOption? _selectedRole;
  AdministratorItem? _selectedParent;
  final _maxLeadsController = TextEditingController();
  bool _isActive = true;
  String? _profilePhotoPath;

  // 2. Bank Details & Address
  final _ifscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchController = TextEditingController();
  final _accountNumberController = TextEditingController();
  bool _ifscVerified = false;

  final _pincodeController = TextEditingController();
  MetaStateOption? _selectedState;
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  // 3. Documents (KYC)
  bool _aadharUploaded = false;
  String? _aadharUrl;
  String? _aadharPath;

  bool _panUploaded = false;
  String? _panUrl;
  String? _panPath;

  bool _passbookUploaded = false;
  String? _passbookUrl;
  String? _passbookPath;

  final List<String> _extraDocuments = [];

  // 4. Outward Payout Matrix (Bank x Loan Category Rates)
  // Map<BankId, Map<CategoryCode, TextEditingController>>
  final Map<int, Map<String, TextEditingController>> _payoutControllers = {};

  // 5. Modular Access Matrix
  // Map<ModuleId, Map<PermissionKey, bool>>
  final Map<int, Map<String, bool>> _modulePermissions = {};
  final Set<int> _expandedModuleIds = {};

  // Leads Status & Modular Access
  String _selectedLeadModule = "BT Topup Enquiries";
  final List<String> _leadModulesList = [
    "BT Topup Enquiries",
    "Used Car Loan",
    "New Car Loan",
    "Car Loan Refinance",
    "Personal Loan",
    "Business Loan",
    "Home Loan",
    "Loan Against Property"
  ];

  final List<String> _leadStatuses = [
    "New Lead",
    "Contact Established",
    "Follow Up",
    "Pick Up",
    "Doc Pending",
    "Doc Received",
    "Sent to Bank",
    "Login",
    "Rejected",
    "Approved",
    "Disbursal Stage",
    "Disbursed",
    "RTO Process(RTO Person)",
    "RTO Done",
    "Payment Requested",
    "Payment in Process",
    "Payment Done(Accounts)",
    "Accounts",
    "Vehicle Handover",
    "PDD Pending",
    "PDD Submitted",
    "Case Completed",
    "Case Cancelled",
    "Case Cancellation",
  ];

  final Map<String, Map<String, bool>> _leadStatusPermissions = {};
  final Map<String, Map<String, Map<String, bool>>> _moduleWiseLeadPermissions = {};

  @override
  void initState() {
    super.initState();

    if (widget.initialAdmin != null) {
      final a = widget.initialAdmin!;
      _nameController.text = a.fullName;
      _usernameController.text = a.username;
      _emailController.text = a.email ?? "";
      _phoneController.text = a.phone ?? "";
      _altPhoneController.text = a.altPhone ?? "";
      _selectedGender = a.gender ?? "Male";
      _isActive = a.status == 1;
      _cityController.text = a.city ?? "";
      if (a.role != null) {
        _selectedRole = MetaRoleOption(
          id: a.role!.id,
          name: a.role!.name,
          code: a.role!.code,
          administratorsCount: 0,
        );
      }
      if (a.parent != null) {
        _selectedParent = AdministratorItem(
          id: a.parent!.id,
          administratorId: "MGR#${a.parent!.id}",
          fullName: a.parent!.fullName,
          username: a.parent!.username ?? "",
        );
      }
      if (a.rawModularAccess != null) {
        _parseAndSetModularAccess(a.rawModularAccess);
      }
    }

    // Listeners for real-time live preview
    _nameController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));

    // Initialize Lead Status Permissions
    for (var s in _leadStatuses) {
      _leadStatusPermissions[s] = {
        'view': false,
        'add': false,
        'edit': false,
        'delete': false,
        'status': false,
        'availability': false,
        'assign': false,
      };
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AdministratorsViewModel>();
      if (vm.metaOptions == null) {
        vm.fetchMetaOptions();
      }
      if (vm.administrators.isEmpty) {
        vm.fetchAdministrators();
      }
      if (vm.roles.isEmpty) {
        vm.fetchRoles();
      }
      if (widget.initialAdmin != null) {
        _loadExistingAdministratorDetails(widget.initialAdmin!.id);
      }
    });
  }

  void _parseAndSetModularAccess(dynamic modularAccessData) {
    if (modularAccessData == null) return;
    debugPrint(
        "[ADMIN_PERMS] Parsing modular access: $modularAccessData (${modularAccessData.runtimeType})");

    if (modularAccessData is String) {
      final trimmed = modularAccessData.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          modularAccessData = jsonDecode(trimmed);
        } catch (e) {
          debugPrint("[ADMIN_PERMS] JSON decode error: $e");
        }
      }
    }

    final vm = context.read<AdministratorsViewModel>();
    final allSystemModules =
        MetaModuleOption.filterToWebCrmModules(vm.metaOptions?.modules ?? []);

    if (modularAccessData is Map) {
      modularAccessData.forEach((modKey, perms) {
        int? modId = int.tryParse(modKey.toString());
        if (modId == null && allSystemModules.isNotEmpty) {
          final q = modKey
              .toString()
              .toLowerCase()
              .replaceAll('_', ' ')
              .replaceAll('-', ' ');
          try {
            modId = allSystemModules.firstWhere((m) {
              final mName = m.name
                  .toLowerCase()
                  .replaceAll('_', ' ')
                  .replaceAll('-', ' ');
              return mName == q || mName.contains(q) || q.contains(mName);
            }).id;
          } catch (_) {}
        }

        if (modId != null) {
          MetaModuleOption? modOpt;
          try {
            modOpt = allSystemModules.firstWhere((m) => m.id == modId);
          } catch (_) {}

          if (perms is Map) {
            _modulePermissions[modId] = {
              'view': (modOpt?.hasView ?? true) &&
                  (perms['can_view'] == true ||
                      perms['can_view'] == 1 ||
                      perms['can_view'] == '1' ||
                      perms['view'] == 1 ||
                      perms['view'] == true ||
                      perms['view'] == '1' ||
                      perms['has_view'] == 1),
              'add': (modOpt?.hasAdd ?? true) &&
                  (perms['can_add'] == true ||
                      perms['can_add'] == 1 ||
                      perms['can_add'] == '1' ||
                      perms['add'] == 1 ||
                      perms['add'] == true ||
                      perms['add'] == '1' ||
                      perms['has_add'] == 1),
              'edit': (modOpt?.hasEdit ?? true) &&
                  (perms['can_edit'] == true ||
                      perms['can_edit'] == 1 ||
                      perms['can_edit'] == '1' ||
                      perms['edit'] == 1 ||
                      perms['edit'] == true ||
                      perms['edit'] == '1' ||
                      perms['has_edit'] == 1),
              'delete': (modOpt?.hasDelete ?? true) &&
                  (perms['can_delete'] == true ||
                      perms['can_delete'] == 1 ||
                      perms['can_delete'] == '1' ||
                      perms['delete'] == 1 ||
                      perms['delete'] == true ||
                      perms['delete'] == '1' ||
                      perms['has_delete'] == 1),
              'status': (modOpt?.hasStatus ?? true) &&
                  (perms['can_status'] == true ||
                      perms['can_status'] == 1 ||
                      perms['can_status'] == '1' ||
                      perms['status'] == 1 ||
                      perms['status'] == true ||
                      perms['status'] == '1' ||
                      perms['has_status'] == 1),
              'availability': (modOpt?.hasCarStatus ?? false) &&
                  (perms['can_car_status'] == true ||
                      perms['can_car_status'] == 1 ||
                      perms['availability'] == 1 ||
                      perms['availability'] == true ||
                      perms['car_status'] == 1 ||
                      perms['car_status'] == true),
              'assign': (modOpt?.hasAssign ?? false) &&
                  (perms['can_assigned_to'] == true ||
                      perms['can_assigned_to'] == 1 ||
                      perms['assign'] == 1 ||
                      perms['assign'] == true),
            };
          } else if (perms == 1 || perms == true || perms == '1') {
            _modulePermissions[modId] = {
              'view': modOpt?.hasView ?? true,
              'add': modOpt?.hasAdd ?? true,
              'edit': modOpt?.hasEdit ?? true,
              'delete': modOpt?.hasDelete ?? true,
              'status': modOpt?.hasStatus ?? true,
              'availability': modOpt?.hasCarStatus ?? false,
              'assign': modOpt?.hasAssign ?? false,
            };
          }
        }
      });
    } else if (modularAccessData is List) {
      for (var item in modularAccessData) {
        if (item is Map) {
          int? modId = int.tryParse(
              item['module_id']?.toString() ?? item['id']?.toString() ?? '');
          if (modId == null &&
              item['name'] != null &&
              allSystemModules.isNotEmpty) {
            final q = item['name'].toString().toLowerCase();
            try {
              modId = allSystemModules
                  .firstWhere((m) => m.name.toLowerCase() == q)
                  .id;
            } catch (_) {}
          }

          if (modId != null) {
            MetaModuleOption? modOpt;
            try {
              modOpt = allSystemModules.firstWhere((m) => m.id == modId);
            } catch (_) {}

            _modulePermissions[modId] = {
              'view': (modOpt?.hasView ?? true) &&
                  (item['can_view'] == true ||
                      item['can_view'] == 1 ||
                      item['view'] == 1 ||
                      item['view'] == true ||
                      item['has_view'] == 1 ||
                      item['has_view'] == true),
              'add': (modOpt?.hasAdd ?? true) &&
                  (item['can_add'] == true ||
                      item['can_add'] == 1 ||
                      item['add'] == 1 ||
                      item['add'] == true ||
                      item['has_add'] == 1 ||
                      item['has_add'] == true),
              'edit': (modOpt?.hasEdit ?? true) &&
                  (item['can_edit'] == true ||
                      item['can_edit'] == 1 ||
                      item['edit'] == 1 ||
                      item['edit'] == true ||
                      item['has_edit'] == 1 ||
                      item['has_edit'] == true),
              'delete': (modOpt?.hasDelete ?? true) &&
                  (item['can_delete'] == true ||
                      item['can_delete'] == 1 ||
                      item['delete'] == 1 ||
                      item['delete'] == true ||
                      item['has_delete'] == 1 ||
                      item['has_delete'] == true),
              'status': (modOpt?.hasStatus ?? true) &&
                  (item['can_status'] == true ||
                      item['can_status'] == 1 ||
                      item['status'] == 1 ||
                      item['status'] == true ||
                      item['has_status'] == 1 ||
                      item['has_status'] == true),
              'availability': (modOpt?.hasCarStatus ?? false) &&
                  (item['can_car_status'] == true ||
                      item['can_car_status'] == 1 ||
                      item['availability'] == 1 ||
                      item['availability'] == true ||
                      item['car_status'] == 1 ||
                      item['car_status'] == true),
              'assign': (modOpt?.hasAssign ?? false) &&
                  (item['can_assigned_to'] == true ||
                      item['can_assigned_to'] == 1 ||
                      item['assign'] == 1 ||
                      item['assign'] == true),
            };
          }
        } else if (item is int || item is String) {
          int? modId = int.tryParse(item.toString());
          if (modId == null && allSystemModules.isNotEmpty) {
            final q = item.toString().toLowerCase();
            try {
              modId = allSystemModules
                  .firstWhere((m) => m.name.toLowerCase() == q)
                  .id;
            } catch (_) {}
          }
          if (modId != null) {
            MetaModuleOption? modOpt;
            try {
              modOpt = allSystemModules.firstWhere((m) => m.id == modId);
            } catch (_) {}

            _modulePermissions[modId] = {
              'view': modOpt?.hasView ?? true,
              'add': modOpt?.hasAdd ?? true,
              'edit': modOpt?.hasEdit ?? true,
              'delete': modOpt?.hasDelete ?? true,
              'status': modOpt?.hasStatus ?? true,
              'availability': modOpt?.hasCarStatus ?? false,
              'assign': modOpt?.hasAssign ?? false,
            };
          }
        }
      }
    }
    debugPrint(
        "[ADMIN_PERMS] Successfully configured modules in app: ${_modulePermissions.keys.toList()}");
    if (mounted) setState(() {});
  }

  void _loadExistingAdministratorDetails(int id) async {
    final vm = context.read<AdministratorsViewModel>();

    // Ensure meta options and roles are loaded so modules can be mapped
    if (vm.metaOptions == null) {
      await vm.fetchMetaOptions();
    }
    if (vm.roles.isEmpty) {
      await vm.fetchRoles();
    }

    final data = await vm.fetchAdministratorDetails(id);
    if (!mounted) return;

    if (data == null) {
      debugPrint("[ADMIN_PERMS] No details returned from server for admin $id");
      return;
    }

    debugPrint(
        "[ADMIN_PERMS] Details received for admin $id: ${data.keys.toList()}");

    // Unpack data whether wrapped in administrator, admin, data or at root
    final adminObj = (data['administrator'] is Map)
        ? Map<String, dynamic>.from(data['administrator'] as Map)
        : (data['admin'] is Map)
            ? Map<String, dynamic>.from(data['admin'] as Map)
            : (data['data'] is Map)
                ? Map<String, dynamic>.from(data['data'] as Map)
                : Map<String, dynamic>.from(data);

    // Populate Banking Details if not already filled
    final banking = adminObj['banking_details'] ?? adminObj['bank'];
    if (banking is Map) {
      final defaultBank = banking['default'] ??
          banking['payout'] ??
          banking['disbursement'] ??
          banking;
      if (defaultBank is Map) {
        if (_bankNameController.text.isEmpty &&
            defaultBank['bank_name'] != null) {
          _bankNameController.text = defaultBank['bank_name'].toString();
        }
        if (_branchController.text.isEmpty &&
            defaultBank['branch_name'] != null) {
          _branchController.text = defaultBank['branch_name'].toString();
        }
        if (_accountNumberController.text.isEmpty &&
            defaultBank['account_number'] != null) {
          _accountNumberController.text =
              defaultBank['account_number'].toString();
        }
        if (_ifscController.text.isEmpty && defaultBank['ifsc_code'] != null) {
          _ifscController.text = defaultBank['ifsc_code'].toString();
        }
      }
    } else {
      if (_bankNameController.text.isEmpty && adminObj['bank_name'] != null) {
        _bankNameController.text = adminObj['bank_name'].toString();
      }
      if (_branchController.text.isEmpty && adminObj['branch_name'] != null) {
        _branchController.text = adminObj['branch_name'].toString();
      }
      if (_accountNumberController.text.isEmpty &&
          adminObj['account_number'] != null) {
        _accountNumberController.text = adminObj['account_number'].toString();
      }
      if (_ifscController.text.isEmpty && adminObj['ifsc_code'] != null) {
        _ifscController.text = adminObj['ifsc_code'].toString();
      }
    }

    // Populate Address Details
    final addr = adminObj['address_details'] ?? adminObj['address'];
    if (addr is Map) {
      if (_addressController.text.isEmpty &&
          (addr['full_address'] != null || addr['address'] != null)) {
        _addressController.text =
            (addr['full_address'] ?? addr['address']).toString();
      }
      if (_pincodeController.text.isEmpty && addr['pincode'] != null) {
        _pincodeController.text = addr['pincode'].toString();
      }
      if (_cityController.text.isEmpty &&
          (addr['city_name'] != null || addr['city'] != null)) {
        _cityController.text = (addr['city_name'] ?? addr['city']).toString();
      }
    } else if (addr is String && _addressController.text.isEmpty) {
      _addressController.text = addr;
    }

    // Populate Job Location & Lead Limits
    if (_jobLocationController.text.isEmpty &&
        adminObj['job_location'] != null) {
      _jobLocationController.text = adminObj['job_location'].toString();
    }
    final limits = adminObj['limits'];
    if (limits is Map &&
        _maxLeadsController.text.isEmpty &&
        limits['lead_view_limit'] != null) {
      _maxLeadsController.text = limits['lead_view_limit'].toString();
    }

    // Populate KYC Documents from server
    final docs = adminObj['documents'];
    if (docs is List) {
      for (var d in docs) {
        if (d is Map) {
          final docName =
              (d['document_name'] ?? d['name'] ?? '').toString().toLowerCase();
          final url = (d['url'] ?? d['document_path'] ?? '').toString();
          if (docName.contains('aadhar')) {
            _aadharUploaded = true;
            _aadharUrl = url;
          } else if (docName.contains('pan')) {
            _panUploaded = true;
            _panUrl = url;
          } else if (docName.contains('passbook') || docName.contains('bank')) {
            _passbookUploaded = true;
            _passbookUrl = url;
          } else {
            final extraName = d['document_name'] ?? d['name'] ?? 'Document';
            if (!_extraDocuments.contains(extraName.toString())) {
              _extraDocuments.add(extraName.toString());
            }
          }
        }
      }
    }

    // Extract Modular Access dynamically
    dynamic access = adminObj['modular_access'] ??
        adminObj['modules'] ??
        adminObj['permissions'] ??
        adminObj['access'] ??
        adminObj['capabilities'] ??
        adminObj['role_modular_access'] ??
        adminObj['role']?['modular_access'] ??
        adminObj['role']?['permissions'] ??
        data['modular_access'] ??
        data['permissions'] ??
        data['role_modular_access'];

    // If still null, check if administrator has role and fallback to that role's modular access
    if (access == null) {
      final roleObj = adminObj['role'];
      int? roleId = (roleObj is Map)
          ? int.tryParse(roleObj['id']?.toString() ?? '')
          : int.tryParse(adminObj['role_id']?.toString() ?? '');
      if (roleId != null && vm.roles.isNotEmpty) {
        try {
          final matchedRole = vm.roles.firstWhere((r) => r.id == roleId);
          access = matchedRole.rawModularAccess;
          debugPrint(
              "[ADMIN_PERMS] Inherited modular_access from role ${matchedRole.name}: $access");
        } catch (_) {}
      }
    }

    debugPrint("[ADMIN_PERMS] Extracted modular_access: $access");
    if (access != null) {
      _parseAndSetModularAccess(access);
    }

    // Extract Lead Status Modular Access dynamically from server
    dynamic leadStatusAccess = adminObj['lead_status_modular_access'] ??
        adminObj['lead_status_permissions'] ??
        adminObj['lead_modular_access'] ??
        data['lead_status_modular_access'] ??
        data['lead_status_permissions'];

    if (leadStatusAccess is String && leadStatusAccess.trim().startsWith('{')) {
      try {
        leadStatusAccess = jsonDecode(leadStatusAccess);
      } catch (_) {}
    }

    if (leadStatusAccess is Map) {
      leadStatusAccess.forEach((modKey, statusVal) {
        if (statusVal is Map) {
          final mKey = modKey.toString();
          _moduleWiseLeadPermissions.putIfAbsent(mKey, () => {});
          statusVal.forEach((statusName, p) {
            if (p is Map) {
              final sName = statusName.toString();
              _moduleWiseLeadPermissions[mKey]![sName] = {
                'view': p['view'] == 1 ||
                    p['view'] == true ||
                    p['can_view'] == 1 ||
                    p['can_view'] == true,
                'add': sName == "New Lead" &&
                    (p['add'] == 1 ||
                        p['add'] == true ||
                        p['can_add'] == 1 ||
                        p['can_add'] == true),
                'edit': p['edit'] == 1 ||
                    p['edit'] == true ||
                    p['can_edit'] == 1 ||
                    p['can_edit'] == true,
                'delete': p['delete'] == 1 ||
                    p['delete'] == true ||
                    p['can_delete'] == 1 ||
                    p['can_delete'] == true,
                'status': p['status'] == 1 ||
                    p['status'] == true ||
                    p['can_status'] == 1 ||
                    p['can_status'] == true,
                'availability': false,
                'assign': false,
              };
            }
          });
        }
      });

      // Populate current active module permissions
      if (_moduleWiseLeadPermissions.containsKey(_selectedLeadModule)) {
        _leadStatusPermissions.clear();
        _moduleWiseLeadPermissions[_selectedLeadModule]!.forEach((k, v) {
          _leadStatusPermissions[k] = Map<String, bool>.from(v);
        });
      } else if (_moduleWiseLeadPermissions.isNotEmpty) {
        _selectedLeadModule = _moduleWiseLeadPermissions.keys.first;
        _leadStatusPermissions.clear();
        _moduleWiseLeadPermissions[_selectedLeadModule]!.forEach((k, v) {
          _leadStatusPermissions[k] = Map<String, bool>.from(v);
        });
      }
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _dobController.dispose();
    _jobLocationController.dispose();
    _maxLeadsController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _branchController.dispose();
    _accountNumberController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _addressController.dispose();

    for (var bMap in _payoutControllers.values) {
      for (var c in bMap.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  // --- FinTech Smart Auto-Fill Handlers ---

  void _onIfscChanged(String val, List<MetaBankOption> banks) {
    final code = val.trim().toUpperCase();
    if (code.length >= 4) {
      String detectedBank = "";
      if (code.startsWith("HDFC")) {
        detectedBank = "HDFC Bank";
      } else if (code.startsWith("ICIC")) {
        detectedBank = "ICICI Bank";
      } else if (code.startsWith("SBIN")) {
        detectedBank = "SBI Bank";
      } else if (code.startsWith("UTIB")) {
        detectedBank = "Axis Bank";
      } else if (code.startsWith("KKBK")) {
        detectedBank = "Kotak Mahindra Bank";
      } else if (code.startsWith("AUBK")) {
        detectedBank = "AU Small Bank";
      } else if (code.startsWith("PUNB")) {
        detectedBank = "Punjab National Bank";
      }

      if (detectedBank.isNotEmpty) {
        setState(() {
          _bankNameController.text = detectedBank;
          _ifscVerified = code.length == 11;
          if (_branchController.text.isEmpty && code.length >= 7) {
            _branchController.text =
                "Branch #${code.substring(code.length - 4)}";
          }
        });
      }
    } else {
      if (_ifscVerified) {
        setState(() => _ifscVerified = false);
      }
    }
  }

  void _onPincodeChanged(String val, List<MetaStateOption> states) {
    if (val.trim().length == 6) {
      // Smart Auto-detection based on Indian Pincode zones
      final prefix = int.tryParse(val.substring(0, 2)) ?? 0;
      MetaStateOption? matchedState;

      if (prefix == 11) {
        matchedState = states
            .where((s) => s.stateName.toLowerCase().contains("delhi"))
            .firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "New Delhi";
      } else if (prefix >= 20 && prefix <= 28) {
        matchedState = states
            .where((s) => s.stateName.toLowerCase().contains("uttar pradesh"))
            .firstOrNull;
        if (_cityController.text.isEmpty) {
          _cityController.text = prefix == 24 ? "Saharanpur" : "Noida";
        }
      } else if (prefix >= 24 && prefix <= 26) {
        matchedState = states
            .where((s) =>
                s.stateName.toLowerCase().contains("uttaranchal") ||
                s.stateName.toLowerCase().contains("uttarakhand"))
            .firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "Dehradun";
      } else if (prefix >= 30 && prefix <= 34) {
        matchedState = states
            .where((s) => s.stateName.toLowerCase().contains("rajasthan"))
            .firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "Jaipur";
      } else if (prefix >= 40 && prefix <= 44) {
        matchedState = states
            .where((s) => s.stateName.toLowerCase().contains("maharashtra"))
            .firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "Mumbai";
      }

      if (matchedState != null) {
        setState(() => _selectedState = matchedState);
        HapticFeedback.lightImpact();
      }
    }
  }

  void _generateRandomPassword() {
    const chars = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789@#\$";
    final rnd = Random();
    final pwd =
        List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join();
    setState(() {
      _passwordController.text = "Fmc@$pwd";
      _obscurePassword = false;
    });

    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: _passwordController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text("Auto-generated & copied: ${_passwordController.text}",
                style: GoogleFonts.poppins()),
          ],
        ),
        backgroundColor: const Color(0xFF003366),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 1, 1),
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
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // --- 1-Tap Outward Payout Presets ---
  void _applyStandardPayoutRates(
      List<MetaBankOption> banks, List<MetaCategoryOption> categories) {
    // Standard FMC Market rates
    final defaults = {
      'USED_CAR_LOAN': '1.50',
      'NEW_CAR_LOAN': '0.75',
      'BT_TOPUP_LOAN': '1.25',
      'CAR_LOAN_REFINANCE': '1.50',
      'PERSONAL_LOAN': '1.00',
    };

    setState(() {
      for (var bank in banks) {
        _payoutControllers.putIfAbsent(bank.id, () => {});
        final bMap = _payoutControllers[bank.id]!;

        for (var cat in categories) {
          bMap.putIfAbsent(cat.code, () => TextEditingController());
          bMap[cat.code]!.text = defaults[cat.code] ?? "1.00";
        }
      }
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Standard 1.5% FMC rates applied across all banks!",
            style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF0284C7),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- 1-Tap Permission Templates ---
  void _applyPermissionTemplate(
      String template, List<MetaModuleOption> modules) {
    setState(() {
      for (var m in modules) {
        _modulePermissions.putIfAbsent(m.id, () => {});
        final perms = _modulePermissions[m.id]!;

        if (template == "Full Admin") {
          perms['view'] = m.hasView;
          perms['add'] = m.hasAdd;
          perms['edit'] = m.hasEdit;
          perms['delete'] = m.hasDelete;
          perms['status'] = m.hasStatus;
          perms['assign'] = m.hasAssign;
          perms['availability'] = m.hasCarStatus;
          perms['car_status'] = m.hasCarStatus;
        } else if (template == "Sales Team") {
          final isSalesMod = m.name.toLowerCase().contains("car") ||
              m.name.toLowerCase().contains("loan") ||
              m.name.toLowerCase().contains("contact") ||
              m.name.toLowerCase().contains("enquir") ||
              m.name.toLowerCase().contains("insurance");
          perms['view'] = isSalesMod && m.hasView;
          perms['add'] = isSalesMod && m.hasAdd;
          perms['edit'] = isSalesMod && m.hasEdit;
          perms['delete'] = false;
          perms['status'] = isSalesMod && m.hasStatus;
          perms['assign'] = isSalesMod && m.hasAssign;
          perms['availability'] = isSalesMod && m.hasCarStatus;
          perms['car_status'] = isSalesMod && m.hasCarStatus;
        } else if (template == "View Only") {
          perms['view'] = m.hasView;
          perms['add'] = false;
          perms['edit'] = false;
          perms['delete'] = false;
          perms['status'] = false;
          perms['assign'] = false;
          perms['availability'] = false;
          perms['car_status'] = false;
        } else if (template == "Reset") {
          perms['view'] = false;
          perms['add'] = false;
          perms['edit'] = false;
          perms['delete'] = false;
          perms['status'] = false;
          perms['assign'] = false;
          perms['availability'] = false;
          perms['car_status'] = false;
        }
      }

      for (var s in _leadStatuses) {
        _leadStatusPermissions.putIfAbsent(s, () => {});
        final sPerms = _leadStatusPermissions[s]!;
        final canAdd = s == "New Lead";
        if (template == "Full Admin") {
          sPerms['view'] = true;
          sPerms['add'] = canAdd;
          sPerms['edit'] = true;
          sPerms['delete'] = true;
          sPerms['status'] = true;
          sPerms['assign'] = false;
          sPerms['availability'] = false;
        } else if (template == "Sales Team") {
          sPerms['view'] = true;
          sPerms['add'] = canAdd;
          sPerms['edit'] = true;
          sPerms['delete'] = false;
          sPerms['status'] = true;
          sPerms['assign'] = false;
          sPerms['availability'] = false;
        } else if (template == "View Only") {
          sPerms['view'] = true;
          sPerms['add'] = false;
          sPerms['edit'] = false;
          sPerms['delete'] = false;
          sPerms['status'] = false;
          sPerms['assign'] = false;
          sPerms['availability'] = false;
        } else if (template == "Reset") {
          sPerms['view'] = false;
          sPerms['add'] = false;
          sPerms['edit'] = false;
          sPerms['delete'] = false;
          sPerms['status'] = false;
          sPerms['assign'] = false;
          sPerms['availability'] = false;
        }
      }
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Template '$template' applied across all modules & pipeline stages!",
            style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF003366),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openUploadSourceModal(String docType) {
    UploadSourceModal.show(
      context: context,
      docType: docType,
      onFilePicked: (filePath) => _setPickedFile(docType, filePath),
    );
  }

  void _setPickedFile(String docType, String filePath) {
    setState(() {
      if (docType == "Aadhar Card") {
        _aadharUploaded = true;
        _aadharPath = filePath;
      } else if (docType == "PAN Card") {
        _panUploaded = true;
        _panPath = filePath;
      } else if (docType == "Bank Passbook") {
        _passbookUploaded = true;
        _passbookPath = filePath;
      }
    });
    HapticFeedback.lightImpact();
    final fileName = filePath.split(Platform.pathSeparator).last;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("$docType attached: $fileName", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _validateStep1() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Full Name to proceed",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Username to proceed",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Phone Number to proceed",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a Role / Designation to proceed",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    return true;
  }

  void _goToStep(int step) {
    if (step < 0 || step > 4) return;
    if (step > _currentStep && _currentStep == 0) {
      if (!_validateStep1()) return;
    }
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  void _submitAdministrator() async {
    if (!_validateStep1()) {
      _goToStep(0);
      return;
    }

    final vm = context.read<AdministratorsViewModel>();

    // Prepare Payout Rates payload
    final Map<String, dynamic> payoutRates = {};
    _payoutControllers.forEach((bankId, catMap) {
      catMap.forEach((catCode, ctrl) {
        if (ctrl.text.trim().isNotEmpty) {
          payoutRates["${bankId}_$catCode"] = ctrl.text.trim();
        }
      });
    });

    // Prepare Modular Access (Clean HTML-checkbox style: send both standard and can_* keys)
    final Map<String, dynamic> formattedModularAccess = {};
    final allModules =
        MetaModuleOption.filterToWebCrmModules(vm.metaOptions?.modules ?? []);
    _modulePermissions.forEach((moduleId, perms) {
      MetaModuleOption? modOpt;
      try {
        modOpt = allModules.firstWhere((m) => m.id == moduleId);
      } catch (_) {}

      final moduleEntry = <String, dynamic>{};
      moduleEntry['module_id'] = moduleId;

      if ((modOpt?.hasView ?? true) && perms['view'] == true) {
        moduleEntry['view'] = 1;
        moduleEntry['can_view'] = 1;
      }
      if ((modOpt?.hasAdd ?? true) && perms['add'] == true) {
        moduleEntry['add'] = 1;
        moduleEntry['can_add'] = 1;
      }
      if ((modOpt?.hasEdit ?? true) && perms['edit'] == true) {
        moduleEntry['edit'] = 1;
        moduleEntry['can_edit'] = 1;
      }
      if ((modOpt?.hasDelete ?? true) && perms['delete'] == true) {
        moduleEntry['delete'] = 1;
        moduleEntry['can_delete'] = 1;
      }
      if ((modOpt?.hasStatus ?? true) && perms['status'] == true) {
        moduleEntry['status'] = 1;
        moduleEntry['can_status'] = 1;
      }
      if ((modOpt?.hasCarStatus ?? false) &&
          (perms['availability'] == true || perms['car_status'] == true)) {
        moduleEntry['availability'] = 1;
        moduleEntry['car_status'] = 1;
        moduleEntry['can_car_status'] = 1;
      }
      if ((modOpt?.hasAssign ?? false) && perms['assign'] == true) {
        moduleEntry['assign'] = 1;
        moduleEntry['can_assigned_to'] = 1;
      }

      if (moduleEntry.length > 1) {
        formattedModularAccess[moduleId.toString()] = moduleEntry;
      }
    });

    // Prepare Lead Status Modular Access
    _moduleWiseLeadPermissions[_selectedLeadModule] =
        _leadStatusPermissions.map((k, v) => MapEntry(k, Map<String, bool>.from(v)));
    final Map<String, dynamic> formattedLeadStatusAccess = {};
    _moduleWiseLeadPermissions.forEach((modKey, sMap) {
      formattedLeadStatusAccess[modKey] = sMap.map(
        (statusKey, perms) => MapEntry(
          statusKey,
          perms.map((k, v) => MapEntry(k, v ? 1 : 0)),
        ),
      );
    });

    final isEdit = widget.initialAdmin != null;

    final Map<String, dynamic> payload = {
      'full_name': _nameController.text.trim(),
      'name': _nameController.text.trim(),
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'mobile': _phoneController.text.trim(),
      if (_altPhoneController.text.trim().isNotEmpty)
        'alt_phone': _altPhoneController.text.trim(),
      if (_dobController.text.trim().isNotEmpty)
        'dob': _dobController.text.trim(),
      'gender': _selectedGender,
      if (_jobLocationController.text.trim().isNotEmpty)
        'job_location': _jobLocationController.text.trim(),
      if (_selectedRole != null) 'role_id': _selectedRole!.id,
      if (_selectedRole?.name != null) 'role': _selectedRole!.name,
      if (_selectedParent != null) 'parent_id': _selectedParent!.id,
      if (_maxLeadsController.text.trim().isNotEmpty)
        'lead_view_limit': int.tryParse(_maxLeadsController.text.trim()),
      'status': _isActive ? 1 : 0,

      // Bank Details
      if (_ifscController.text.trim().isNotEmpty)
        'ifsc_code': _ifscController.text.trim(),
      if (_bankNameController.text.trim().isNotEmpty)
        'bank_name': _bankNameController.text.trim(),
      if (_branchController.text.trim().isNotEmpty)
        'branch_name': _branchController.text.trim(),
      if (_accountNumberController.text.trim().isNotEmpty)
        'account_number': _accountNumberController.text.trim(),

      // Address Details
      if (_pincodeController.text.trim().isNotEmpty)
        'pincode': _pincodeController.text.trim(),
      if (_selectedState != null) 'state_id': _selectedState!.id,
      if (_cityController.text.trim().isNotEmpty)
        'city': _cityController.text.trim(),
      if (_addressController.text.trim().isNotEmpty)
        'full_address': _addressController.text.trim(),
      if (_addressController.text.trim().isNotEmpty)
        'address': _addressController.text.trim(),

      // KYC
      'aadhar_uploaded': _aadharUploaded ? 1 : 0,
      'pan_uploaded': _panUploaded ? 1 : 0,
      'passbook_uploaded': _passbookUploaded ? 1 : 0,

      // Payout & Permissions (Always send modular_access & access so revokes/grants are dynamically saved)
      if (payoutRates.isNotEmpty) 'outward_payout_rates': payoutRates,
      'modular_access': formattedModularAccess,
      'access': formattedModularAccess,
      if (formattedLeadStatusAccess.isNotEmpty)
        'lead_status_modular_access': formattedLeadStatusAccess,
    };

    if (isEdit) {
      payload['_method'] = 'PUT';
      if (_passwordController.text.trim().isNotEmpty) {
        payload['password'] = _passwordController.text.trim();
        payload['password_confirmation'] = _passwordController.text.trim();
      }
    } else {
      final pwd = _passwordController.text.trim().isNotEmpty
          ? _passwordController.text.trim()
          : "Fmc@123456";
      payload['password'] = pwd;
      payload['password_confirmation'] = pwd;
    }

    dynamic finalPayload = payload;
    if (_aadharPath != null || _panPath != null || _passbookPath != null) {
      final formMap = Map<String, dynamic>.from(payload);
      if (_aadharPath != null) {
        final fName = _aadharPath!.split(Platform.pathSeparator).last;
        formMap['aadhar_image'] =
            await MultipartFile.fromFile(_aadharPath!, filename: fName);
        formMap['aadhar_card'] =
            await MultipartFile.fromFile(_aadharPath!, filename: fName);
      }
      if (_panPath != null) {
        final fName = _panPath!.split(Platform.pathSeparator).last;
        formMap['pan_image'] =
            await MultipartFile.fromFile(_panPath!, filename: fName);
        formMap['pan_card'] =
            await MultipartFile.fromFile(_panPath!, filename: fName);
      }
      if (_passbookPath != null) {
        final fName = _passbookPath!.split(Platform.pathSeparator).last;
        formMap['passbook_image'] =
            await MultipartFile.fromFile(_passbookPath!, filename: fName);
        formMap['passbook'] =
            await MultipartFile.fromFile(_passbookPath!, filename: fName);
      }
      finalPayload = FormData.fromMap(formMap);
    }

    debugPrint("SUBMITTING ADMINISTRATOR PAYLOAD: $payload");

    final success = isEdit
        ? await vm.updateAdministrator(widget.initialAdmin!.id, finalPayload)
        : await vm.createAdministrator(payload);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? "Administrator updated successfully!"
                : "Administrator published successfully!",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.pop(context, true);
    } else {
      final err = vm.errorMessage ??
          (isEdit
              ? "Failed to update administrator"
              : "Failed to publish administrator");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: Colors.redAccent, size: 24),
              const SizedBox(width: 8),
              Text(isEdit ? "Update Failed" : "Publish Failed",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            err,
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF334155)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366)),
              child:
                  Text("OK", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  // Step Completion Checkers
  bool get _isStep1Complete =>
      _nameController.text.trim().isNotEmpty &&
      _usernameController.text.trim().isNotEmpty &&
      _selectedRole != null &&
      _phoneController.text.trim().isNotEmpty;

  bool get _isStep2Complete =>
      _ifscController.text.trim().isNotEmpty ||
      _bankNameController.text.trim().isNotEmpty ||
      _cityController.text.trim().isNotEmpty;

  int get _uploadedDocsCount =>
      (_aadharUploaded ? 1 : 0) +
      (_panUploaded ? 1 : 0) +
      (_passbookUploaded ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdministratorsViewModel>();
    final meta = vm.metaOptions;
    final admins = vm.administrators;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          _goToStep(_currentStep - 1);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            widget.initialAdmin != null
                ? "Edit Administrator"
                : "Add Administrator",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: const Color(0xFF0F172A),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Color(0xFF0F172A)),
            onPressed: () {
              if (_currentStep > 0) {
                _goToStep(_currentStep - 1);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF003366).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Step ${_currentStep + 1} of 5",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 🧭 Premium Interactive Multi-Step Stepper Header
            AdminStepperHeader(
              currentStep: _currentStep,
              isStep1Complete: _isStep1Complete,
              isStep2Complete: _isStep2Complete,
              uploadedDocsCount: _uploadedDocsCount,
              onStepTap: (step) {
                if (step <= _currentStep || _validateStep1()) {
                  _goToStep(step);
                }
              },
            ),

            // 👤 Compact Profile Header for Steps 2 to 5
            if (_currentStep > 0)
              AdminMiniProfileHeader(
                name: _nameController.text,
                username: _usernameController.text,
                roleName: _selectedRole?.name ?? "Role Pending",
                isActive: _isActive,
              ),

            // 📄 Step-by-Step Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      // Live Staff ID Card Preview on Step 1
                      LiveStaffBadge(
                        name: _nameController.text,
                        username: _usernameController.text,
                        roleName: _selectedRole?.name,
                        isActive: _isActive,
                        profilePhotoPath: _profilePhotoPath,
                      ),
                      Expanded(
                        child: Step1AccountContactTab(
                          profilePhotoPath: _profilePhotoPath,
                          onUploadPhotoTap: () =>
                              _openUploadSourceModal("Profile Photo"),
                          nameController: _nameController,
                          usernameController: _usernameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          onTogglePassword: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          onGeneratePassword: _generateRandomPassword,
                          phoneController: _phoneController,
                          altPhoneController: _altPhoneController,
                          dobController: _dobController,
                          onPickDate: _pickDate,
                          selectedGender: _selectedGender,
                          onGenderChanged: (g) =>
                              setState(() => _selectedGender = g),
                          jobLocationController: _jobLocationController,
                          selectedParent: _selectedParent,
                          potentialManagers: _getPotentialManagers(vm),
                          allAdmins: admins,
                          onParentChanged: (p) =>
                              setState(() => _selectedParent = p),
                          selectedRole: _selectedRole,
                          onRoleFieldTap: () => RolePickerModal.show(
                            context: context,
                            roles: meta?.roles ?? [],
                            selectedRole: _selectedRole,
                            onRoleSelected: (r) => setState(() {
                              _selectedRole = r;
                              _selectedParent = null;
                            }),
                            onRoleDeleted: (id) {
                              if (_selectedRole?.id == id) {
                                setState(() => _selectedRole = null);
                              }
                            },
                          ),
                          maxLeadsController: _maxLeadsController,
                          isActive: _isActive,
                          onStatusChanged: (v) => setState(() => _isActive = v),
                        ),
                      ),
                    ],
                  ),
                  Step2BankAddressTab(
                    ifscController: _ifscController,
                    ifscVerified: _ifscVerified,
                    onIfscChanged: (v) =>
                        _onIfscChanged(v, meta?.payoutBanks ?? []),
                    bankNameController: _bankNameController,
                    branchController: _branchController,
                    accountNumberController: _accountNumberController,
                    pincodeController: _pincodeController,
                    onPincodeChanged: (v) =>
                        _onPincodeChanged(v, meta?.states ?? []),
                    states: meta?.states ?? [],
                    selectedState: _selectedState,
                    onStateChanged: (s) => setState(() => _selectedState = s),
                    cityController: _cityController,
                    addressController: _addressController,
                  ),
                  Step3DocumentsTab(
                    aadharUploaded: _aadharUploaded,
                    aadharUrl: _aadharUrl,
                    aadharPath: _aadharPath,
                    onAadharPicked: (p) => _setPickedFile("Aadhar Card", p),
                    panUploaded: _panUploaded,
                    panUrl: _panUrl,
                    panPath: _panPath,
                    onPanPicked: (p) => _setPickedFile("PAN Card", p),
                    passbookUploaded: _passbookUploaded,
                    passbookUrl: _passbookUrl,
                    passbookPath: _passbookPath,
                    onPassbookPicked: (p) => _setPickedFile("Bank Passbook", p),
                    extraDocuments: _extraDocuments,
                    onAddExtraDocument: () => setState(() => _extraDocuments
                        .add("Extra Document #${_extraDocuments.length + 1}")),
                    onRemoveExtraDocument: (doc) =>
                        setState(() => _extraDocuments.remove(doc)),
                  ),
                  Step4PayoutMatrixTab(
                    banks: meta?.payoutBanks ?? [],
                    categories: meta?.payoutCategories ?? [],
                    payoutControllers: _payoutControllers,
                    onApplyStandardRates: () => _applyStandardPayoutRates(
                        meta?.payoutBanks ?? [], meta?.payoutCategories ?? []),
                  ),
                  Step5ModularAccessTab(
                    modules: MetaModuleOption.filterToWebCrmModules(
                        meta?.modules ?? []),
                    modulePermissions: _modulePermissions,
                    expandedModuleIds: _expandedModuleIds,
                    leadModulesList: _leadModulesList,
                    selectedLeadModule: _selectedLeadModule,
                    onSelectLeadModule: (newMod) {
                      setState(() {
                        _moduleWiseLeadPermissions[_selectedLeadModule] =
                            _leadStatusPermissions.map(
                                (k, v) => MapEntry(k, Map<String, bool>.from(v)));
                        _selectedLeadModule = newMod;
                        if (_moduleWiseLeadPermissions.containsKey(newMod)) {
                          _leadStatusPermissions.clear();
                          _moduleWiseLeadPermissions[newMod]!.forEach((k, v) {
                            _leadStatusPermissions[k] = Map<String, bool>.from(v);
                          });
                        } else {
                          // Copy current configuration into new module by default
                          _moduleWiseLeadPermissions[newMod] =
                              _leadStatusPermissions.map(
                                  (k, v) => MapEntry(k, Map<String, bool>.from(v)));
                        }
                      });
                    },
                    leadStatuses: _leadStatuses,
                    leadStatusPermissions: _leadStatusPermissions,
                    onApplyPermissionTemplate: (tpl) =>
                    _applyPermissionTemplate(
                        tpl,
                        MetaModuleOption.filterToWebCrmModules(
                            meta?.modules ?? [])),
                    onPermissionsChanged: () => setState(() {}),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: AdminBottomBar(
          currentStep: _currentStep,
          isSubmitting: vm.isCreating,
          isEditMode: widget.initialAdmin != null,
          onBack: () => _goToStep(_currentStep - 1),
          onContinue: () {
            if (_currentStep < 4) {
              _goToStep(_currentStep + 1);
            } else {
              _submitAdministrator();
            }
          },
        ),
      ),
    );
  }

  // ==========================================
  // 🏢 Dynamic Potential Managers Finder
  // ==========================================
  List<AdministratorItem> _getPotentialManagers(AdministratorsViewModel vm) {
    if (_selectedRole == null) return [];

    // Find the role in vm.roles to check parent_id or parent_name
    CrmRoleItem? roleMatch;
    for (final r in vm.roles) {
      if (r.id == _selectedRole!.id ||
          r.code.toLowerCase() == _selectedRole!.code.toLowerCase()) {
        roleMatch = r;
        break;
      }
    }

    final parentRoleId = roleMatch?.parentId ?? 0;
    final parentRoleName = roleMatch?.parentName?.toLowerCase().trim();
    final allAdmins = vm.administrators.where((a) => a.status == 1).toList();

    // 1. Direct match with configured parent role in CRM hierarchy
    if (parentRoleId > 0 ||
        (parentRoleName != null && parentRoleName.isNotEmpty)) {
      final directMatches = allAdmins.where((a) {
        if (a.role == null) return false;
        if (parentRoleId > 0 && a.role!.id == parentRoleId) return true;
        if (parentRoleName != null &&
            a.role!.name.toLowerCase().contains(parentRoleName)) {
          return true;
        }
        return false;
      }).toList();

      if (directMatches.isNotEmpty) {
        return directMatches;
      }
    }

    // 2. Hierarchical Senior Administrators (Super Admin, CEO, TL, ZSM, Area Sales Managers)
    final seniorManagers = allAdmins.where((a) {
      if (a.role == null) return false;
      final rName = a.role!.name.toLowerCase();
      final rCode = a.role!.code.toLowerCase();
      final isSenior = rName.contains('ceo') ||
          rName.contains('super admin') ||
          rName.contains('zonal') ||
          rName.contains('sales manager') ||
          rName.contains('tele sales') ||
          rName.contains('team leader') ||
          rName.contains('tl') ||
          rName.contains('area') ||
          rCode.contains('sm') ||
          rCode.contains('tl') ||
          rCode.contains('afd') ||
          a.id == 5 || // Mohammad Aman
          a.id == 69 || // Nitish Bhardwaj (CEO)
          a.id == 80; // Tayyab Ali

      // Exclude Dealers or lower-level tele caller staff
      final isDealer = rName.contains('dealer') || rCode == 'd';
      return isSenior && !isDealer;
    }).toList();

    return seniorManagers.isNotEmpty
        ? seniorManagers.take(3).toList()
        : allAdmins.take(3).toList();
  }
}
