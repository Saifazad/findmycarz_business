part of 'add_car_screen.dart';

extension _AddCarSectionsRulesPart on _AddCarScreenState {
  // ================= HOME SECTIONS CARD (IMAGE 1) =================
  Widget _buildHomeSectionsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _homeSectionsExpanded = !_homeSectionsExpanded;
              });
            },
            onLongPress: _showHomeSectionsPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.desktop_windows_outlined,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Home Sections",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (!_homeSectionsExpanded &&
                      _selectedHomeSections.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${_selectedHomeSections.length} selected",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _homeSectionsExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_homeSectionsExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // List of Home Sections (No search bar as per Image 1)
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _homeSectionsList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No home sections found",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _homeSectionsList.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (ctx, i) {
                        final item = _homeSectionsList[i];
                        final name = item["name"] as String;
                        final hasPriceTabs =
                            item["hasPriceTabs"] as bool? ?? false;
                        final isSelected = _selectedHomeSections.contains(name);
                        return _buildHomeSectionRowItem(
                            name, hasPriceTabs, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingHomeSection = !_isAddingHomeSection;
                });
              },
              borderRadius: _isAddingHomeSection
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingHomeSection
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Home Panel Form (Image 2)
            if (_isAddingHomeSection) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Home Panel ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Panel Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Panel Name input field (height 44px)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newHomeSectionNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Name (e.g. Explore Hatchbacks by Price, Recently Added)",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price Filter Tabs Card with Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sell_outlined,
                                      size: 16,
                                      color: Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Price Filter Tabs",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Show / Hide budget tabs on homepage",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _newHomeSectionHasPriceTabs =
                                    !_newHomeSectionHasPriceTabs;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 44,
                              height: 24,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: _newHomeSectionHasPriceTabs
                                    ? const Color(0xFF14B8A6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _newHomeSectionHasPriceTabs
                                      ? const Color(0xFF14B8A6)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Align(
                                alignment: _newHomeSectionHasPriceTabs
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _newHomeSectionHasPriceTabs
                                        ? Colors.white
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Update and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewHomeSection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Update",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingHomeSection = false;
                              _newHomeSectionNameCtrl.clear();
                              _newHomeSectionHasPriceTabs = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _saveNewHomeSection() {
    final val = _newHomeSectionNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        final existingIndex = _homeSectionsList.indexWhere((item) =>
            (item["name"] as String).toLowerCase() == val.toLowerCase());
        if (existingIndex == -1) {
          _homeSectionsList.insert(0, {
            "name": val,
            "hasPriceTabs": _newHomeSectionHasPriceTabs,
          });
        } else {
          _homeSectionsList[existingIndex]["hasPriceTabs"] =
              _newHomeSectionHasPriceTabs;
        }
        if (!_selectedHomeSections.contains(val)) {
          _selectedHomeSections.add(val);
        }
        _isAddingHomeSection = false;
        _newHomeSectionNameCtrl.clear();
        _newHomeSectionHasPriceTabs = false;
      });
    }
  }

  Widget _buildHomeSectionRowItem(
    String name,
    bool hasPriceTabs,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenHomeSections.contains(name);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (isSelected) {
                _selectedHomeSections.remove(name);
              } else {
                _selectedHomeSections.add(name);
              }
            });
            onStateChange?.call();
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Square Checkbox
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF10B981) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Section Name
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: isHidden
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF0F172A),
                        decoration:
                            isHidden ? TextDecoration.lineThrough : null,
                        decorationColor: const Color(0xFF94A3B8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasPriceTabs) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Price Tabs",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  if (_hiddenHomeSections.contains(name)) {
                    _hiddenHomeSections.remove(name);
                  } else {
                    _hiddenHomeSections.add(name);
                  }
                  if (!_selectedHomeSections.contains(name)) {
                    _selectedHomeSections.add(name);
                  }
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit (Select & open edit dialog)
            InkWell(
              onTap: () {
                setState(() {
                  if (!_selectedHomeSections.contains(name)) {
                    _selectedHomeSections.add(name);
                  }
                });
                onStateChange?.call();
                _editHomePanelCustomDialog(name, hasPriceTabs,
                    onUpdated: onStateChange);
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () =>
                  _deleteHomeSectionDialog(name, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Edit Home Panel Dialog (Image 3)
  void _editHomePanelCustomDialog(
    String name,
    bool initialHasPriceTabs, {
    VoidCallback? onUpdated,
  }) {
    final editCtrl = TextEditingController(text: name);
    bool hasPriceTabs = initialHasPriceTabs;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Home Panel ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Panel Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Panel Name input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: editCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price Filter Tabs card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sell_outlined,
                                      size: 16,
                                      color: Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Price Filter Tabs",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Show / Hide budget tabs on homepage",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setDState(() {
                                hasPriceTabs = !hasPriceTabs;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 44,
                              height: 24,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: hasPriceTabs
                                    ? const Color(0xFF14B8A6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasPriceTabs
                                      ? const Color(0xFF14B8A6)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Align(
                                alignment: hasPriceTabs
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasPriceTabs
                                        ? Colors.white
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Update and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final val = editCtrl.text.trim();
                            if (val.isNotEmpty) {
                              setState(() {
                                final idx = _homeSectionsList
                                    .indexWhere((item) => item["name"] == name);
                                if (idx != -1) {
                                  _homeSectionsList[idx] = {
                                    "name": val,
                                    "hasPriceTabs": hasPriceTabs,
                                  };
                                }
                                if (_selectedHomeSections.contains(name)) {
                                  _selectedHomeSections.remove(name);
                                  _selectedHomeSections.add(val);
                                }
                                if (_hiddenHomeSections.contains(name)) {
                                  _hiddenHomeSections.remove(name);
                                  _hiddenHomeSections.add(val);
                                }
                              });
                              onUpdated?.call();
                              Navigator.pop(ctx);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Update",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteHomeSectionDialog(String name, {VoidCallback? onDeleted}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete Home Section",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$name\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _homeSectionsList.removeWhere((item) => item["name"] == name);
                  _selectedHomeSections.remove(name);
                  _hiddenHomeSections.remove(name);
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showHomeSectionsPicker() {
    final tempSelected = List<String>.from(_selectedHomeSections);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Home Sections",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            tempSelected.isEmpty
                                ? "None selected"
                                : "${tempSelected.length} sections selected",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedHomeSections = List.from(tempSelected);
                          });
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Done",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _homeSectionsList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final item = _homeSectionsList[i];
                        final name = item["name"] as String;
                        final hasPriceTabs =
                            item["hasPriceTabs"] as bool? ?? false;
                        final isChecked = tempSelected.contains(name);
                        return _buildHomeSectionRowItem(
                          name,
                          hasPriceTabs,
                          isChecked,
                          onTapOverride: () {
                            setModalState(() {
                              if (isChecked) {
                                tempSelected.remove(name);
                              } else {
                                tempSelected.add(name);
                              }
                            });
                          },
                          onStateChange: () {
                            setModalState(() {});
                          },
                        );
                      },
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

  // ================= RTO RULES CARD (IMAGE 1) =================
  Widget _buildRtoRulesCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _rtoRulesExpanded = !_rtoRulesExpanded;
              });
            },
            onLongPress: _showRtoRulesPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_outlined,
                    color: Color(0xFFF43F5E),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "RTO Rules",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _rtoRulesExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_rtoRulesExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // List of RTO Rules
            Column(
              children: List.generate(_rtoRulesList.length, (i) {
                final item = _rtoRulesList[i];
                final state = item['state'] as String? ?? "State";
                final maxPrice = item['maxPrice'] as String? ?? "0";
                final percentage = item['percentage'] as String? ?? "0";
                final formattedRule = "$state: Max â‚¹$maxPrice ($percentage%)";
                final isSelected = _selectedRtoRule == formattedRule;
                final isHidden = _hiddenRtoRules.contains(formattedRule);

                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRtoRule = formattedRule;
                        });
                      },
                      child: Container(
                        decoration: (isSelected && !isHidden)
                            ? const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFF2563EB),
                                    width: 3.5,
                                  ),
                                ),
                              )
                            : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: (isSelected && !isHidden) ? 12.5 : 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Rule Text (Blue when selected, strikethrough when hidden)
                            Expanded(
                              child: Text(
                                formattedRule,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: (isSelected && !isHidden)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : (isSelected
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF0F172A)),
                                  decoration: isHidden
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: const Color(0xFF94A3B8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Action 1: Eye (Toggle Hide & Select)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_hiddenRtoRules.contains(formattedRule)) {
                                    _hiddenRtoRules.remove(formattedRule);
                                    _selectedRtoRule = formattedRule;
                                  } else {
                                    _hiddenRtoRules.add(formattedRule);
                                    if (_selectedRtoRule == formattedRule) {
                                      _selectedRtoRule = "";
                                    }
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  isHidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF14B8A6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Action 2: Edit (Select & Toggle Inline Edit Form)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedRtoRule = formattedRule;
                                  if (_editingRtoRuleIndex == i) {
                                    _editingRtoRuleIndex = null;
                                  } else {
                                    _editingRtoRuleIndex = i;
                                    _isAddingRtoRule = false;
                                    _editRtoState = state;
                                    _editRtoMaxPriceCtrl.text = maxPrice;
                                    _editRtoPercentageCtrl.text = percentage;
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Action 3: Delete
                            InkWell(
                              onTap: () =>
                                  _deleteRtoRuleDialog(i, formattedRule),
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 19,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Inline Edit RTO Rule Form (Image 3)
                    if (_editingRtoRuleIndex == i) ...[
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Edit Rto ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  "State",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4338CA),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // State Dropdown
                            _buildRtoStateDropdown(
                              value: _editRtoState,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _editRtoState = val);
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Max Price Limit
                            Text(
                              "Max Price Limit",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRtoPrefixInput(
                              prefix: "â‚¹",
                              controller: _editRtoMaxPriceCtrl,
                              hintText: "Max Price",
                            ),
                            const SizedBox(height: 12),

                            // Percentage
                            Text(
                              "Percentage",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRtoPercentageInput(
                              controller: _editRtoPercentageCtrl,
                              hintText: "Percentage",
                            ),
                            const SizedBox(height: 14),

                            // Save and Cancel buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _saveEditedRtoRule(i),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF14B8A6),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _editingRtoRuleIndex = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF818CF8),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingRtoRule = !_isAddingRtoRule;
                  if (_isAddingRtoRule) {
                    _editingRtoRuleIndex = null;
                  }
                });
              },
              borderRadius: _isAddingRtoRule
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingRtoRule
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add RTO Rule Form (Image 2)
            if (_isAddingRtoRule) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add RTO Rule ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "State",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // State Dropdown
                    _buildRtoStateDropdown(
                      value: _newRtoState,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _newRtoState = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Max Price Limit
                    Text(
                      "Max Price Limit",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRtoPrefixInput(
                      prefix: "â‚¹",
                      controller: _newRtoMaxPriceCtrl,
                      hintText: "Max Price",
                    ),
                    const SizedBox(height: 12),

                    // Percentage
                    Text(
                      "Percentage",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRtoPercentageInput(
                      controller: _newRtoPercentageCtrl,
                      hintText: "Percentage",
                    ),
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewRtoRule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingRtoRule = false;
                              _newRtoMaxPriceCtrl.clear();
                              _newRtoPercentageCtrl.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildRtoStateDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: const Icon(
              Icons.map_outlined,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    _indianStates.contains(value) ? value : _indianStates.first,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: _indianStates.map((s) {
                  return DropdownMenuItem<String>(
                    value: s,
                    child: Text(
                      s,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: s == "State"
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtoPrefixInput({
    required String prefix,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: Text(
              prefix,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtoPercentageInput({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: Text(
              "%",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // Stepper up/down
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  final cur = double.tryParse(controller.text) ?? 0;
                  final next = cur + 1;
                  controller.text = next == next.toInt()
                      ? next.toInt().toString()
                      : next.toStringAsFixed(2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Icon(Icons.arrow_drop_up,
                      size: 16, color: Color(0xFF64748B)),
                ),
              ),
              InkWell(
                onTap: () {
                  final cur = double.tryParse(controller.text) ?? 0;
                  if (cur > 0) {
                    final next = cur - 1;
                    final valid = next < 0 ? 0.0 : next;
                    controller.text = valid == valid.toInt()
                        ? valid.toInt().toString()
                        : valid.toStringAsFixed(2);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Icon(Icons.arrow_drop_down,
                      size: 16, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveNewRtoRule() {
    final state = _newRtoState == "State" ? "Gujarat" : _newRtoState;
    final maxPrice = _newRtoMaxPriceCtrl.text.trim().isEmpty
        ? "500,000"
        : _newRtoMaxPriceCtrl.text.trim();
    final percentage = _newRtoPercentageCtrl.text.trim().isEmpty
        ? "12.00"
        : _newRtoPercentageCtrl.text.trim();

    final formattedRule = "$state: Max â‚¹$maxPrice ($percentage%)";
    setState(() {
      _rtoRulesList.insert(0, {
        "state": state,
        "maxPrice": maxPrice,
        "percentage": percentage,
      });
      _selectedRtoRule = formattedRule;
      _isAddingRtoRule = false;
      _newRtoMaxPriceCtrl.clear();
      _newRtoPercentageCtrl.clear();
      _newRtoState = "State";
    });
  }

  void _saveEditedRtoRule(int index) {
    if (index >= 0 && index < _rtoRulesList.length) {
      final state = _editRtoState == "State"
          ? (_rtoRulesList[index]["state"] as String? ?? "Gujarat")
          : _editRtoState;
      final maxPrice = _editRtoMaxPriceCtrl.text.trim().isEmpty
          ? (_rtoRulesList[index]["maxPrice"] as String? ?? "500,000")
          : _editRtoMaxPriceCtrl.text.trim();
      final percentage = _editRtoPercentageCtrl.text.trim().isEmpty
          ? (_rtoRulesList[index]["percentage"] as String? ?? "0")
          : _editRtoPercentageCtrl.text.trim();

      final oldRuleString =
          "${_rtoRulesList[index]['state']}: Max â‚¹${_rtoRulesList[index]['maxPrice']} (${_rtoRulesList[index]['percentage']}%)";
      final newRuleString = "$state: Max â‚¹$maxPrice ($percentage%)";

      setState(() {
        _rtoRulesList[index] = {
          "state": state,
          "maxPrice": maxPrice,
          "percentage": percentage,
        };
        if (_selectedRtoRule == oldRuleString) {
          _selectedRtoRule = newRuleString;
        }
        if (_hiddenRtoRules.contains(oldRuleString)) {
          _hiddenRtoRules.remove(oldRuleString);
          _hiddenRtoRules.add(newRuleString);
        }
        _editingRtoRuleIndex = null;
      });
    }
  }

  void _deleteRtoRuleDialog(int index, String ruleString) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete RTO Rule",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$ruleString\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (index >= 0 && index < _rtoRulesList.length) {
                    _rtoRulesList.removeAt(index);
                  }
                  if (_selectedRtoRule == ruleString) {
                    _selectedRtoRule = _rtoRulesList.isNotEmpty
                        ? "${_rtoRulesList.first['state']}: Max â‚¹${_rtoRulesList.first['maxPrice']} (${_rtoRulesList.first['percentage']}%)"
                        : "Select";
                  }
                  _hiddenRtoRules.remove(ruleString);
                  if (_editingRtoRuleIndex == index) {
                    _editingRtoRuleIndex = null;
                  }
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRtoRulesPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select RTO Rule",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: _rtoRulesList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = _rtoRulesList[i];
                    final state = item['state'] as String? ?? "State";
                    final maxPrice = item['maxPrice'] as String? ?? "0";
                    final percentage = item['percentage'] as String? ?? "0";
                    final formattedRule =
                        "$state: Max â‚¹$maxPrice ($percentage%)";
                    final isSelected = _selectedRtoRule == formattedRule;
                    return ListTile(
                      title: Text(
                        formattedRule,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFF2563EB))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedRtoRule = formattedRule;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= TCS RULES CARD (IMAGE 1) =================
  Widget _buildTcsRulesCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _tcsRulesExpanded = !_tcsRulesExpanded;
              });
            },
            onLongPress: _showTcsRulesPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.percent,
                    color: Color(0xFF0D9488),
                    size: 19,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "TCS Rules",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _tcsRulesExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_tcsRulesExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // List of TCS Rules
            Column(
              children: List.generate(_tcsRulesList.length, (i) {
                final item = _tcsRulesList[i];
                final abovePrice = item['abovePrice'] as String? ?? "0";
                final percentage = item['percentage'] as String? ?? "0";
                final formattedRule = "Above â‚¹$abovePrice @ $percentage%";
                final isSelected = _selectedTcsRule == formattedRule;
                final isHidden = _hiddenTcsRules.contains(formattedRule);

                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTcsRule = formattedRule;
                        });
                      },
                      child: Container(
                        decoration: (isSelected && !isHidden)
                            ? const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFF2563EB),
                                    width: 3.5,
                                  ),
                                ),
                              )
                            : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: (isSelected && !isHidden) ? 12.5 : 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Rule Text (Blue when selected, strikethrough when hidden)
                            Expanded(
                              child: Text(
                                formattedRule,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: (isSelected && !isHidden)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : (isSelected
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF0F172A)),
                                  decoration: isHidden
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: const Color(0xFF94A3B8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Action 1: Eye (Toggle Hide & Select)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_hiddenTcsRules.contains(formattedRule)) {
                                    _hiddenTcsRules.remove(formattedRule);
                                    _selectedTcsRule = formattedRule;
                                  } else {
                                    _hiddenTcsRules.add(formattedRule);
                                    if (_selectedTcsRule == formattedRule) {
                                      _selectedTcsRule = "";
                                    }
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  isHidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF14B8A6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Action 2: Edit (Select & Toggle Inline Edit Form)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTcsRule = formattedRule;
                                  if (_editingTcsRuleIndex == i) {
                                    _editingTcsRuleIndex = null;
                                  } else {
                                    _editingTcsRuleIndex = i;
                                    _isAddingTcsRule = false;
                                    _editTcsAbovePriceCtrl.text = abovePrice;
                                    _editTcsPercentageCtrl.text = percentage;
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Action 3: Delete
                            InkWell(
                              onTap: () =>
                                  _deleteTcsRuleDialog(i, formattedRule),
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 19,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Inline Edit TCS Rule Form (Image 3)
                    if (_editingTcsRuleIndex == i) ...[
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Edit Tcs ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  "Above Price",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4338CA),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Above Price Input
                            _buildRtoPrefixInput(
                              prefix: "â‚¹",
                              controller: _editTcsAbovePriceCtrl,
                              hintText: "Above Price",
                            ),
                            const SizedBox(height: 12),

                            // Percentage Label
                            Text(
                              "Percentage",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRtoPrefixInput(
                              prefix: "%",
                              controller: _editTcsPercentageCtrl,
                              hintText: "Percentage",
                            ),
                            const SizedBox(height: 14),

                            // Save and Cancel buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _saveEditedTcsRule(i),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF14B8A6),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _editingTcsRuleIndex = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF818CF8),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingTcsRule = !_isAddingTcsRule;
                  if (_isAddingTcsRule) {
                    _editingTcsRuleIndex = null;
                  }
                });
              },
              borderRadius: _isAddingTcsRule
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingTcsRule
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add TCS Rule Form (Image 2)
            if (_isAddingTcsRule) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Tcs ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Above Price",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Above Price Input
                    _buildRtoPrefixInput(
                      prefix: "â‚¹",
                      controller: _newTcsAbovePriceCtrl,
                      hintText: "Above Price",
                    ),
                    const SizedBox(height: 12),

                    // Percentage Label
                    Text(
                      "Percentage",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRtoPrefixInput(
                      prefix: "%",
                      controller: _newTcsPercentageCtrl,
                      hintText: "Percentage",
                    ),
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewTcsRule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingTcsRule = false;
                              _newTcsAbovePriceCtrl.clear();
                              _newTcsPercentageCtrl.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _saveNewTcsRule() {
    final abovePrice = _newTcsAbovePriceCtrl.text.trim().isEmpty
        ? "500,000"
        : _newTcsAbovePriceCtrl.text.trim();
    final percentage = _newTcsPercentageCtrl.text.trim().isEmpty
        ? "12.00"
        : _newTcsPercentageCtrl.text.trim();

    final formattedRule = "Above â‚¹$abovePrice @ $percentage%";
    setState(() {
      _tcsRulesList.insert(0, {
        "abovePrice": abovePrice,
        "percentage": percentage,
      });
      _selectedTcsRule = formattedRule;
      _isAddingTcsRule = false;
      _newTcsAbovePriceCtrl.clear();
      _newTcsPercentageCtrl.clear();
    });
  }

  void _saveEditedTcsRule(int index) {
    if (index >= 0 && index < _tcsRulesList.length) {
      final abovePrice = _editTcsAbovePriceCtrl.text.trim().isEmpty
          ? (_tcsRulesList[index]["abovePrice"] as String? ?? "500,000")
          : _editTcsAbovePriceCtrl.text.trim();
      final percentage = _editTcsPercentageCtrl.text.trim().isEmpty
          ? (_tcsRulesList[index]["percentage"] as String? ?? "12.00")
          : _editTcsPercentageCtrl.text.trim();

      final oldRuleString =
          "Above â‚¹${_tcsRulesList[index]['abovePrice']} @ ${_tcsRulesList[index]['percentage']}%";
      final newRuleString = "Above â‚¹$abovePrice @ $percentage%";

      setState(() {
        _tcsRulesList[index] = {
          "abovePrice": abovePrice,
          "percentage": percentage,
        };
        if (_selectedTcsRule == oldRuleString) {
          _selectedTcsRule = newRuleString;
        }
        if (_hiddenTcsRules.contains(oldRuleString)) {
          _hiddenTcsRules.remove(oldRuleString);
          _hiddenTcsRules.add(newRuleString);
        }
        _editingTcsRuleIndex = null;
      });
    }
  }

  void _deleteTcsRuleDialog(int index, String ruleString) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete TCS Rule",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$ruleString\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (index >= 0 && index < _tcsRulesList.length) {
                    _tcsRulesList.removeAt(index);
                  }
                  if (_selectedTcsRule == ruleString) {
                    _selectedTcsRule = _tcsRulesList.isNotEmpty
                        ? "Above â‚¹${_tcsRulesList.first['abovePrice']} @ ${_tcsRulesList.first['percentage']}%"
                        : "Select";
                  }
                  _hiddenTcsRules.remove(ruleString);
                  if (_editingTcsRuleIndex == index) {
                    _editingTcsRuleIndex = null;
                  }
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTcsRulesPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select TCS Rule",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: _tcsRulesList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = _tcsRulesList[i];
                    final abovePrice = item['abovePrice'] as String? ?? "0";
                    final percentage = item['percentage'] as String? ?? "0";
                    final formattedRule = "Above â‚¹$abovePrice @ $percentage%";
                    final isSelected = _selectedTcsRule == formattedRule;
                    return ListTile(
                      title: Text(
                        formattedRule,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFF2563EB))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedTcsRule = formattedRule;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showManufacturerPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = _manufacturers
                .where((m) => m.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Manufacturer",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search manufacturer...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No manufacturer found",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = _selectedManufacturer == item;
                              return _buildManufacturerRowItem(
                                item,
                                isSelected,
                                onTapOverride: () {
                                  setState(() {
                                    _selectedManufacturer = item;
                                    if (_selectedModel ==
                                        "Select manufacturer first") {
                                      _selectedModel = "Select model";
                                    }
                                  });
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      _showAddManufacturerDialog(
                        onAdded: () => setModalState(() {}),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Manufacturer",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
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

  void _showModelPicker() {
    final hasMfg =
        _selectedManufacturer.isNotEmpty && _selectedManufacturer != "Select";
    List<String> defaultModels = [
      "ALCAZAR",
      "ALCAZAR 1.5 AT PLATINUM(O) 6S",
      "ALCAZAR 1.5 MT PLATINUM 7S",
      "Aura",
      "AURA 1.2MT CNG S",
      "AURA 1.2MT KAPPA S",
      "Swift",
      "Creta",
      "Nexon",
      "Thar",
      "City",
      "Fortuner",
      "Seltos",
      "Brezza",
      "Baleno",
      "Innova"
    ];
    List<String> baseModels = hasMfg
        ? (_modelsByManufacturer[_selectedManufacturer] ?? defaultModels)
        : defaultModels;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        bool isAdding = false;
        final modalAddCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = baseModels
                .where((m) => m.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Model (${hasMfg ? _selectedManufacturer : 'All'})",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search model...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              hasMfg
                                  ? "No model found for $_selectedManufacturer"
                                  : "Select Manufacturer First",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = _selectedModel == item;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildModelRowItem(
                                    item,
                                    isSelected,
                                    onTapOverride: () {
                                      setState(() {
                                        _selectedModel = item;
                                        if (_carNameCtrl.text.isEmpty) {
                                          _carNameCtrl.text = hasMfg
                                              ? "$_selectedManufacturer $item"
                                              : item;
                                        }
                                      });
                                      Navigator.pop(ctx);
                                    },
                                    onStateChange: () => setModalState(() {}),
                                  ),
                                  if (_editingModel == item) ...[
                                    _buildInlineEditModelForm(item,
                                        onStateChange: () =>
                                            setModalState(() {})),
                                  ],
                                ],
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        isAdding = !isAdding;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Model",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Inline Add Model Form (Image: media_1795243797134_c5c8999b.png)
                  if (isAdding) ...[
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Model ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                "Model Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    border: Border(
                                      right:
                                          BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_note_rounded,
                                    size: 19,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: modalAddCtrl,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final val = modalAddCtrl.text.trim();
                                  if (val.isNotEmpty) {
                                    final targetMfg =
                                        _selectedManufacturer != "Select"
                                            ? _selectedManufacturer
                                            : (_manufacturers.isNotEmpty
                                                ? _manufacturers.first
                                                : "Maruti Suzuki");
                                    setState(() {
                                      if (!_modelsByManufacturer
                                          .containsKey(targetMfg)) {
                                        _modelsByManufacturer[targetMfg] = [];
                                      }
                                      if (!_modelsByManufacturer[targetMfg]!
                                          .contains(val)) {
                                        _modelsByManufacturer[targetMfg]!
                                            .insert(0, val);
                                      }
                                      _selectedModel = val;
                                      if (_carNameCtrl.text.isEmpty) {
                                        _carNameCtrl.text =
                                            _selectedManufacturer != "Select"
                                                ? "$_selectedManufacturer $val"
                                                : val;
                                      }
                                    });
                                    setModalState(() {
                                      isAdding = false;
                                      modalAddCtrl.clear();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    isAdding = false;
                                    modalAddCtrl.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF818CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBodyTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        bool isAdding = false;
        final modalAddCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = _bodyTypes
                .where((b) => b.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Body Type",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search body type...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No body type found",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = _selectedBodyType == item;
                              return _buildBodyTypeRowItem(
                                item,
                                isSelected,
                                onTapOverride: () {
                                  setState(() => _selectedBodyType = item);
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        isAdding = !isAdding;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Body Type",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Inline Add Body Type Form
                  if (isAdding) ...[
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Body Type ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                "Body Type Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    border: Border(
                                      right:
                                          BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_note_rounded,
                                    size: 19,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: modalAddCtrl,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final val = modalAddCtrl.text.trim();
                                  if (val.isNotEmpty) {
                                    setState(() {
                                      if (!_bodyTypes.contains(val)) {
                                        _bodyTypes.insert(0, val);
                                      }
                                      _selectedBodyType = val;
                                    });
                                    setModalState(() {
                                      isAdding = false;
                                      modalAddCtrl.clear();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    isAdding = false;
                                    modalAddCtrl.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF818CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        bool isAdding = false;
        final modalAddCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = _exteriorColors.where((item) {
              final name = (item["name"] as String).toLowerCase();
              return name.contains(query.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Exterior Color",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search color...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No color found",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final name = item["name"] as String;
                              final color = item["color"] as Color;
                              final border = (item["border"] ?? false) as bool;
                              final isSelected = _selectedExteriorColor == name;
                              return _buildExteriorColorRowItem(
                                name,
                                color,
                                border,
                                isSelected,
                                onTapOverride: () {
                                  setState(() => _selectedExteriorColor = name);
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        isAdding = !isAdding;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Color",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Inline Add Color Form
                  if (isAdding) ...[
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Color ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                "Color Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    border: Border(
                                      right:
                                          BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_note_rounded,
                                    size: 19,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: modalAddCtrl,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final val = modalAddCtrl.text.trim();
                                  if (val.isNotEmpty) {
                                    final exists = _exteriorColors.any((c) =>
                                        (c["name"] as String).toLowerCase() ==
                                        val.toLowerCase());
                                    if (!exists) {
                                      setState(() {
                                        _exteriorColors.insert(0, {
                                          "name": val,
                                          "color": const Color(0xFF94A3B8),
                                          "border": false,
                                        });
                                        _selectedExteriorColor = val;
                                      });
                                    } else {
                                      setState(() {
                                        _selectedExteriorColor = val;
                                      });
                                    }
                                    setModalState(() {
                                      isAdding = false;
                                      modalAddCtrl.clear();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    isAdding = false;
                                    modalAddCtrl.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF818CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

}
