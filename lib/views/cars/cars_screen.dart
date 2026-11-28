import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../core/constants/api_config.dart';
import '../../core/theme/app_colors.dart';
import '../../models/inventory_vehicle_model.dart';
import '../../viewmodels/inventory_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import '../widgets/car_image_preview_dialog.dart';
import 'add_car_screen.dart';

class CarsScreen extends StatefulWidget {
  final String title;
  final String endpoint;
  const CarsScreen({
    super.key,
    this.title = "Live Inventory",
    this.endpoint = ApiConfig.cars,
  });

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  bool _isDarkMode = false;
  String _activeTab = "All Cars"; // "All Cars", "New Cars", "Used Cars"
  final int _entriesPerPage = 10;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  late final PagingController<int, InventoryVehicle> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.keys == null || state.keys!.isEmpty) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.length < _entriesPerPage) return null;
      return (state.keys!.last) + 1;
    },
    fetchPage: (pageKey) async {
      final vm = Provider.of<InventoryViewModel>(context, listen: false);
      return await vm.fetchVehiclesPage(
        pageKey: pageKey,
        pageSize: _entriesPerPage,
        activeTab: _activeTab,
        searchQuery: _searchQuery,
        endpoint: widget.endpoint,
      );
    },
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InventoryViewModel>().fetchStats();
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void showAddVehicleModal() {
    final inventoryVm = context.read<InventoryViewModel>();
    final uidCtrl = TextEditingController(
        text: "#CARUID0${970 + inventoryVm.vehicles.length}");
    final makeModelCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    final yearCtrl = TextEditingController(text: "2023");
    final phoneCtrl = TextEditingController();
    final locationCtrl = TextEditingController(text: "Dehradun, Uttaranchal");
    final companyCtrl = TextEditingController(text: "Find My Car");
    final agentCtrl = TextEditingController(text: "Auto Care Mohammad Sajid");
    String condition = "Used";
    String status = "Published";

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add New Vehicle",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            color:
                                _isDarkMode ? Colors.white70 : Colors.black54,
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: "Vehicle Make & Model",
                        controller: makeModelCtrl,
                        hint: "e.g. TOYOTA | INNOVA CRYSTA",
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Variant / Subtitle",
                        controller: subtitleCtrl,
                        hint: "e.g. 2.4 ZX 7 STR DIESEL",
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: "Year",
                              controller: yearCtrl,
                              hint: "e.g. 2022",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Condition",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _isDarkMode
                                        ? Colors.white70
                                        : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isDarkMode
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: condition,
                                      isExpanded: true,
                                      dropdownColor: _isDarkMode
                                          ? const Color(0xFF1E293B)
                                          : Colors.white,
                                      items: ["Used", "New"].map((c) {
                                        return DropdownMenuItem(
                                          value: c,
                                          child: Text(
                                            c,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: _isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setModalState(() => condition = val);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Company / Client",
                        controller: companyCtrl,
                        hint: "e.g. Find My Car",
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Agent",
                        controller: agentCtrl,
                        hint: "e.g. Auto Care Mohammad Sajid",
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Phone Number",
                        controller: phoneCtrl,
                        hint: "e.g. 9897323603",
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Location",
                        controller: locationCtrl,
                        hint: "e.g. Dehradun, Uttaranchal",
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              final newCar = InventoryVehicle(
                                id: uidCtrl.text.trim(),
                                makeModel:
                                    makeModelCtrl.text.trim().toUpperCase(),
                                subtitle: subtitleCtrl.text.trim(),
                                image: "assets/images/car1.webp",
                                condition: condition,
                                year: yearCtrl.text.trim(),
                                availability: "Available",
                                company: companyCtrl.text.trim(),
                                agent: agentCtrl.text.trim(),
                                phone: phoneCtrl.text.trim().isNotEmpty
                                    ? phoneCtrl.text.trim()
                                    : "9897323603",
                                location: locationCtrl.text.trim(),
                                date: "Today",
                                status: status,
                                visibility: "Public",
                              );
                              context
                                  .read<InventoryViewModel>()
                                  .addVehicle(newCar);
                              _pagingController.refresh();
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Vehicle added successfully!"),
                                  backgroundColor: Color(0xFF10B981),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Save Vehicle",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white70 : const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: _isDarkMode ? Colors.white38 : Colors.grey.shade400,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _exportToExcel() {
    final inventoryVm = context.read<InventoryViewModel>();
    final selectedCount = inventoryVm.selectedCount;
    final totalCount = inventoryVm.vehicles.length;
    final message = selectedCount > 0
        ? "Exporting $selectedCount selected vehicles to Excel..."
        : "Exporting all $totalCount vehicles to Excel...";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(message, style: GoogleFonts.poppins(fontSize: 13)),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryVm = context.watch<InventoryViewModel>();
    final selectedCount = inventoryVm.selectedCount;

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
      drawer: const CrmDrawer(),
      bottomNavigationBar: selectedCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: _isDarkMode ? 0.3 : 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: _isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox + "2 selected"
                    InkWell(
                      onTap: () {
                        final allSelected =
                            inventoryVm.vehicles.every((v) => v.isSelected);
                        for (var v in inventoryVm.vehicles) {
                          v.isSelected = !allSelected;
                        }
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: inventoryVm.vehicles.isNotEmpty &&
                                  inventoryVm.vehicles
                                      .every((v) => v.isSelected),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (val) {
                                for (var v in inventoryVm.vehicles) {
                                  v.isSelected = val ?? false;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "$selectedCount selected",
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "Export Selected" Green Button
                    ElevatedButton(
                      onPressed: _exportToExcel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Export Selected",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          const AdminProfileAvatar(),
          const SizedBox(width: 14),
        ],
      ),
      body: PagingListener<int, InventoryVehicle>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Buttons Row: "+ Add Vehicle" (Royal Blue) & "Export to Excel" (White with Blue Border)
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 135,
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddCarScreen()),
                            );
                          },
                          icon: const Icon(Icons.add,
                              size: 16, color: Colors.white),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Add Vehicle",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 135,
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: _exportToExcel,
                          icon: const Icon(
                            Icons.file_download_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Export to Excel",
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 2. Tabs: All Cars | New Cars | Used Cars
                  Row(
                    children: [
                      _buildTab("All Cars"),
                      const SizedBox(width: 22),
                      _buildTab("New Cars"),
                      const SizedBox(width: 22),
                      _buildTab("Used Cars"),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: _isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                  const SizedBox(height: 12),

                  // 3. Search Field (Full Width)
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                      _pagingController.refresh();
                    },
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search..",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: _isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF003366),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                                _pagingController.refresh();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: _isDarkMode
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _isDarkMode
                              ? const Color(0xFF00A3FF)
                              : const Color(0xFF003366),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await Future.wait([
                    context.read<InventoryViewModel>().fetchStats(),
                    Future.sync(() => _pagingController.refresh()),
                  ]);
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      sliver: PagedSliverList<int, InventoryVehicle>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate:
                            PagedChildBuilderDelegate<InventoryVehicle>(
                          itemBuilder: (context, vehicle, index) =>
                              _buildVehicleCard(vehicle, index),
                          noItemsFoundIndicatorBuilder: (context) =>
                              _buildNoItemsFound(),
                          firstPageProgressIndicatorBuilder: (context) =>
                              _buildLoadingIndicator(),
                          newPageProgressIndicatorBuilder: (context) =>
                              _buildLoadingIndicator(),
                          firstPageErrorIndicatorBuilder: (context) =>
                              _buildErrorIndicator(state.error),
                          newPageErrorIndicatorBuilder: (context) =>
                              _buildErrorIndicator(state.error),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(InventoryVehicle vehicle, int index) {
    final dividerColor =
        _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final availLower = vehicle.availability.toLowerCase();
    final Color availBg;
    final Color availText;
    final Color availBorder;
    if (availLower == 'upcoming') {
      availBg = const Color(0xFFFFFBEB);
      availText = const Color(0xFFB45309);
      availBorder = const Color(0xFFFDE68A);
    } else if (availLower == 'sold') {
      availBg = const Color(0xFFFEF2F2);
      availText = const Color(0xFFDC2626);
      availBorder = const Color(0xFFFECACA);
    } else {
      availBg = AppColors.chipAvailableBg;
      availText = AppColors.chipAvailableText;
      availBorder = const Color(0xFFA7F3D0);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Row: Checkbox + UID + Year + Condition + Availability + #Index
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: vehicle.isSelected,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: _isDarkMode
                          ? const Color(0xFF64748B)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    onChanged: (val) {
                      setState(() {
                        vehicle.isSelected = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  vehicle.id,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                if (vehicle.year.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vehicle.year,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode
                            ? Colors.white70
                            : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Text(
                    vehicle.condition,
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: availBg,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: availBorder),
                  ),
                  child: Text(
                    vehicle.availability,
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: availText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "#${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // Middle Row: Car Thumbnail + Make/Model + Subtitle + Client
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: vehicle.image.startsWith('http')
                      ? () => showCarImagePreviewDialog(
                            context,
                            vehicle.images.isNotEmpty
                                ? vehicle.images
                                : [vehicle.image],
                          )
                      : null,
                  child: Container(
                    width: 104,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: vehicle.image.startsWith('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              vehicle.image,
                              width: 104,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.directions_car_rounded,
                                size: 28,
                                color: _isDarkMode
                                    ? Colors.white60
                                    : const Color(0xFF546E7A),
                              ),
                            ),
                          )
                        : Icon(
                            Icons.directions_car_rounded,
                            size: 28,
                            color: _isDarkMode
                                ? Colors.white60
                                : const Color(0xFF546E7A),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.makeModel,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (vehicle.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          vehicle.subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            color: _isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 13,
                            color: _isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Client: ",
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              color: _isDarkMode
                                  ? Colors.grey.shade400
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              vehicle.company,
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // Agent + Phone + Date Section
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Agent: ",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF64748B),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        vehicle.agent,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 13,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      vehicle.phone,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: _isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const Spacer(),
                    if (vehicle.date.isNotEmpty) ...[
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: _isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vehicle.date,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: _isDarkMode
                              ? Colors.grey.shade400
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // Bottom Row: Status Pills on Left + Action Icons on Right
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Row(
              children: [
                // Status 1: Inactive or Published
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: vehicle.status.toLowerCase() == "inactive"
                        ? AppColors.chipInactiveBg
                        : AppColors.chipPublishedBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    vehicle.status,
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: vehicle.status.toLowerCase() == "inactive"
                          ? AppColors.chipInactiveText
                          : AppColors.chipPublishedText,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Status 2: Public / Private
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.chipPublicBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    vehicle.visibility,
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chipPublicText,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Status 3: Availability
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: availBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    vehicle.availability,
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: availText,
                    ),
                  ),
                ),

                const Spacer(),

                // Action Icons: Edit, Delete, History
                InkWell(
                  onTap: () => _editVehicle(vehicle),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 17,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _deleteVehicle(vehicle),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      size: 17,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _viewVehicleLogs(vehicle),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.history,
                      size: 17,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIndicator(Object? error) {
    final msg = error?.toString().replaceFirst("Exception: ", "") ??
        "Failed to load vehicles";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.paletteRed,
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: _isDarkMode ? Colors.white70 : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _pagingController.refresh(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
              ),
              child: Text(
                "Retry",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoItemsFound() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 44,
              color: _isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              "No entries found",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // Tab Item with Blue Indicator
  Widget _buildTab(String title) {
    final isActive = _activeTab == title;
    return InkWell(
      onTap: () {
        if (_activeTab != title) {
          setState(() {
            _activeTab = title;
          });
          _pagingController.refresh();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 2.2,
            ),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? AppColors.primary
                : (_isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  void _editVehicle(InventoryVehicle v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCarScreen(
          carUid: v.id,
          isEdit: true,
        ),
      ),
    );
  }

  void _deleteVehicle(InventoryVehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: const Color(0xFFEF4D56),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Confirm Delete?",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Body Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Text(
                "This action cannot be undone. Checks for dependencies will be performed.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: _isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                  height: 1.4,
                ),
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF95A0C5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(74, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4D56),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(70, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      context.read<InventoryViewModel>().deleteVehicle(v.id);
                      _pagingController.refresh();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Vehicle deleted successfully!"),
                          backgroundColor: Color(0xFFEF4D56),
                        ),
                      );
                    },
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
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
    );
  }

  void _viewVehicleLogs(InventoryVehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle Logs",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              v.id,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: _isDarkMode ? Colors.white60 : Colors.black45,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: _isDarkMode
                    ? const Color(0xFF334155)
                    : const Color(0xFFF1F5F9),
              ),
              // Body Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                child: Column(
                  children: [
                    // Vehicle Info Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isDarkMode
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car_filled_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v.makeModel,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${v.condition} • ${v.year}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: _isDarkMode
                                        ? Colors.white60
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Log Detail Items
                    _buildLogRow(
                      icon: Icons.calendar_today_outlined,
                      label: "Listed Date",
                      value: v.date,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.location_on_outlined,
                      label: "Location",
                      value: v.location,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.person_outline_rounded,
                      label: "Managed by",
                      value: v.agent,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.business_outlined,
                      label: "Company",
                      value: v.company,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.info_outline_rounded,
                      label: "Status & Availability",
                      value: "${v.status} (${v.availability})",
                      customValue: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: v.status.toLowerCase() == "published"
                                  ? AppColors.chipPublishedBg
                                  : AppColors.chipInactiveBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              v.status,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: v.status.toLowerCase() == "published"
                                    ? AppColors.chipPublishedText
                                    : AppColors.chipInactiveText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.chipAvailableBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              v.availability,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.chipAvailableText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      isDarkMode: _isDarkMode,
                    ),
                  ],
                ),
              ),
              // Footer Action
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Close",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? customValue,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isDarkMode
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color:
                        isDarkMode ? Colors.white54 : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                customValue ??
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
