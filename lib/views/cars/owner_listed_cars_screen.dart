import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/inventory_vehicle_model.dart';
import '../../viewmodels/inventory_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import '../widgets/car_image_preview_dialog.dart';
import 'add_car_screen.dart';

class OwnerListedCarsScreen extends StatefulWidget {
  const OwnerListedCarsScreen({super.key});

  @override
  State<OwnerListedCarsScreen> createState() => _OwnerListedCarsScreenState();
}

class _OwnerListedCarsScreenState extends State<OwnerListedCarsScreen> {
  bool _isDarkMode = false;
  final int _entriesPerPage = 10;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  late final PagingController<int, OwnerListedCar> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.keys == null || state.keys!.isEmpty) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.length < _entriesPerPage) return null;
      return (state.keys!.last) + 1;
    },
    fetchPage: (pageKey) async {
      final vm = Provider.of<InventoryViewModel>(context, listen: false);
      return await vm.fetchOwnerListedCarsPage(
        pageKey: pageKey,
        pageSize: _entriesPerPage,
        searchQuery: _searchQuery,
      );
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        titleSpacing: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "Owner Listed Cars",
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: _isDarkMode ? Colors.white : const Color(0xFF334155),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          const AdminProfileAvatar(),
          const SizedBox(width: 14),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search Field
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
                    hintText: "Search owner or car...",
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
                const SizedBox(height: 12),

                // 2. Dynamic Filtered Count (Without Add button)
                Consumer<InventoryViewModel>(
                  builder: (context, vm, _) {
                    final count = vm.ownerListedTotal > 0
                        ? vm.ownerListedTotal
                        : vm.ownerListedCars.length;
                    return Text(
                      count == 0
                          ? "No Cars"
                          : count == 1
                              ? "1 Car"
                              : "$count Cars",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : AppColors.text,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Cars Cards List
          Expanded(
            child: PagingListener<int, OwnerListedCar>(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      sliver: PagedSliverList<int, OwnerListedCar>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate:
                            PagedChildBuilderDelegate<OwnerListedCar>(
                          itemBuilder: (ctx, car, index) => _buildCarCard(car),
                          noItemsFoundIndicatorBuilder: (ctx) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.directions_car_outlined,
                                    size: 44,
                                    color: _isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No Owner Listed Cars Found",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _isDarkMode
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          firstPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          newPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          firstPageErrorIndicatorBuilder: (ctx) =>
                              _buildErrorIndicator(state.error),
                          newPageErrorIndicatorBuilder: (ctx) =>
                              _buildErrorIndicator(state.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIndicator(Object? error) {
    final msg = error?.toString().replaceFirst("Exception: ", "") ??
        "Failed to load owner listed cars";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Color(0xFFEF4444),
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

  Widget _buildCarCard(OwnerListedCar car) {
    final isActive = car.status == "Active";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
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
          // Row 1: Car Image + Model/Year Info + Status Box Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image with border
              GestureDetector(
                onTap: car.image.isNotEmpty
                    ? () => showCarImagePreviewDialog(
                          context,
                          car.images.isNotEmpty ? car.images : [car.image],
                        )
                    : null,
                child: Container(
                  width: 94,
                  height: 68,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _isDarkMode
                        ? const Color(0xFF0F172A)
                        : Colors.white,
                    border: Border.all(
                      color: _isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: car.image.startsWith('http')
                        ? Image.network(
                            car.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.directions_car_rounded,
                              size: 26,
                              color: _isDarkMode
                                  ? Colors.white60
                                  : const Color(0xFF546E7A),
                            ),
                          )
                        : (car.image.isNotEmpty
                            ? Image.asset(
                                car.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.directions_car_rounded,
                                  size: 26,
                                  color: _isDarkMode
                                      ? Colors.white60
                                      : const Color(0xFF546E7A),
                                ),
                              )
                            : Icon(
                                Icons.directions_car_rounded,
                                size: 26,
                                color: _isDarkMode
                                    ? Colors.white60
                                    : const Color(0xFF546E7A),
                              )),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Car Title & Year Model
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.title,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode
                            ? Colors.white
                            : const Color(0xFF0F172A),
                        letterSpacing: 0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.yearModel,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.chipActiveBg
                      : AppColors.chipInactiveBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  car.status,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? AppColors.chipActiveText
                        : AppColors.chipInactiveText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 10),

          // Row 2: Owner Info (Left) + Price & Kms (Right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Owner Icon & Name + Phone
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circle User Icon
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.inputIcon,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person,
                        size: 11,
                        color: AppColors.inputIcon,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.ownerName,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            car.ownerPhone,
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              color: _isDarkMode
                                  ? Colors.grey.shade400
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Price & Kms (Right-Aligned)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    car.price,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    car.kms,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            thickness: 1,
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 10),

          // Row 3: Location & Listed Date (Left) + Actions (Right)
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 13,
                color: _isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "${car.location} • Listed ${car.listedDate}",
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Action Icons: Edit & Delete
              InkWell(
                onTap: () => _editCar(car),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => _deleteCar(car),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editCar(OwnerListedCar car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCarScreen(
          carUid: car.id.startsWith("#") ? car.id : "#${car.id}",
          isEdit: true,
        ),
      ),
    );
  }

  void _deleteCar(OwnerListedCar car) {
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
                      context
                          .read<InventoryViewModel>()
                          .deleteOwnerListedCar(car.id);
                      _pagingController.refresh();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Car deleted successfully!"),
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
}
