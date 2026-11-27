part of 'add_car_screen.dart';

extension _AddCarFeaturesMediaSeoPart on _AddCarScreenState {
  // ================= FEATURES CARD (IMAGE 1) =================
  Widget _buildFeaturesCard() {
    final search = _featuresSearchCtrl.text.trim().toLowerCase();
    final filtered =
        _featuresList.where((f) => f.toLowerCase().contains(search)).toList();

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
                _featuresExpanded = !_featuresExpanded;
              });
            },
            onLongPress: _showFeaturesPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.format_list_bulleted_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Features",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (!_featuresExpanded && _selectedFeatures.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${_selectedFeatures.length} selected",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _featuresExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_featuresExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find features...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _featuresSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find features...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF003366)),
                  ),
                  isDense: true,
                ),
              ),
            ),

            // List of Features
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No features found",
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
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (ctx, i) {
                        final feature = filtered[i];
                        final isSelected = _selectedFeatures.contains(feature);
                        return _buildFeatureRowItem(feature, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingFeature = !_isAddingFeature;
                });
              },
              borderRadius: _isAddingFeature
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingFeature
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

            // Inline Add Feature Form (Image 2)
            if (_isAddingFeature) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Feature ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Feature Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Feature Name input field (height 44px)
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
                              controller: _newFeatureNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
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
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewFeature,
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
                              _isAddingFeature = false;
                              _newFeatureNameCtrl.clear();
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

  void _saveNewFeature() {
    final val = _newFeatureNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        if (!_featuresList.contains(val)) {
          _featuresList.insert(0, val);
        }
        if (!_selectedFeatures.contains(val)) {
          _selectedFeatures.add(val);
        }
        _isAddingFeature = false;
        _newFeatureNameCtrl.clear();
      });
    }
  }

  Widget _buildFeatureRowItem(
    String feature,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenFeatures.contains(feature);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (isSelected) {
                _selectedFeatures.remove(feature);
              } else {
                _selectedFeatures.add(feature);
              }
            });
            onStateChange?.call();
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Checkbox (Square matching Image 1)
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

            // Feature Name
            Expanded(
              child: Text(
                feature,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select checkbox)
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle hide
                  if (_hiddenFeatures.contains(feature)) {
                    _hiddenFeatures.remove(feature);
                  } else {
                    _hiddenFeatures.add(feature);
                  }
                  // Auto-select checkbox
                  if (!_selectedFeatures.contains(feature)) {
                    _selectedFeatures.add(feature);
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

            // Action 2: Edit (Select checkbox & open edit dialog)
            InkWell(
              onTap: () {
                setState(() {
                  if (!_selectedFeatures.contains(feature)) {
                    _selectedFeatures.add(feature);
                  }
                });
                onStateChange?.call();
                _editFeatureCustomDialog(feature, onUpdated: onStateChange);
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
                  _deleteFeatureDialogDirect(feature, onDeleted: onStateChange),
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

  // Edit Feature Dialog (Image 3)
  void _editFeatureCustomDialog(String feature, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: feature);

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
                          "Edit Feature ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Feature Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Feature Name input
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
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
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
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final val = editCtrl.text.trim();
                            if (val.isNotEmpty) {
                              setState(() {
                                final idx = _featuresList.indexOf(feature);
                                if (idx != -1) {
                                  _featuresList[idx] = val;
                                }
                                if (_selectedFeatures.contains(feature)) {
                                  _selectedFeatures.remove(feature);
                                  _selectedFeatures.add(val);
                                }
                                if (_hiddenFeatures.contains(feature)) {
                                  _hiddenFeatures.remove(feature);
                                  _hiddenFeatures.add(val);
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
                            "Save",
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

  void _deleteFeatureDialogDirect(String feature, {VoidCallback? onDeleted}) {
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
                "Delete Feature",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$feature\"? This action cannot be undone.",
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
                  _featuresList.remove(feature);
                  _selectedFeatures.remove(feature);
                  _hiddenFeatures.remove(feature);
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

  void _showFeaturesPicker() {
    List<String> tempSelected = List.from(_selectedFeatures);

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
              height: MediaQuery.of(context).size.height * 0.78,
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
                            "Select Vehicle Features",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            "${tempSelected.length} features selected",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _addNewFeatureDialog(
                              modalCtx,
                              setModalState,
                              tempSelected,
                            ),
                            icon: const Icon(Icons.add, size: 14),
                            label: Text(
                              "Add",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF003366),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedFeatures = List.from(tempSelected);
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
                            child: Text(
                              "Done",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _featuresList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final feature = _featuresList[i];
                        final isChecked = tempSelected.contains(feature);
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              if (isChecked) {
                                tempSelected.remove(feature);
                              } else {
                                tempSelected.add(feature);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: isChecked,
                                    activeColor: const Color(0xFF003366),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF94A3B8),
                                      width: 1.5,
                                    ),
                                    onChanged: (val) {
                                      setModalState(() {
                                        if (val == true) {
                                          tempSelected.add(feature);
                                        } else {
                                          tempSelected.remove(feature);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: isChecked
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: _hiddenFeatures.contains(feature)
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF0F172A),
                                      decoration:
                                          _hiddenFeatures.contains(feature)
                                              ? TextDecoration.lineThrough
                                              : null,
                                      decorationColor: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Action Buttons: Eye, Edit, Delete
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 1. Eye (Toggle Hide & Select)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (_hiddenFeatures
                                              .contains(feature)) {
                                            _hiddenFeatures.remove(feature);
                                          } else {
                                            _hiddenFeatures.add(feature);
                                          }
                                          if (!_selectedFeatures
                                              .contains(feature)) {
                                            _selectedFeatures.add(feature);
                                          }
                                        });
                                        setModalState(() {
                                          if (!tempSelected.contains(feature)) {
                                            tempSelected.add(feature);
                                          }
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDFA),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          _hiddenFeatures.contains(feature)
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 16,
                                          color:
                                              _hiddenFeatures.contains(feature)
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF14B8A6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // 2. Edit
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (!_selectedFeatures
                                              .contains(feature)) {
                                            _selectedFeatures.add(feature);
                                          }
                                        });
                                        setModalState(() {
                                          if (!tempSelected.contains(feature)) {
                                            tempSelected.add(feature);
                                          }
                                        });
                                        _editFeatureCustomDialog(
                                          feature,
                                          onUpdated: () => setModalState(() {}),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // 3. Delete
                                    InkWell(
                                      onTap: () => _deleteFeatureDialogDirect(
                                        feature,
                                        onDeleted: () {
                                          setModalState(() {
                                            tempSelected.remove(feature);
                                          });
                                        },
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: Color(0xFF94A3B8),
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

  void _addNewFeatureDialog(
    BuildContext modalCtx,
    StateSetter setModalState,
    List<String> tempSelected,
  ) {
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_circle_outline,
                    color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Add New Feature",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Feature Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: newCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "e.g. Panoramic Sunroof",
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF003366), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = newCtrl.text.trim();
                if (name.isNotEmpty && !_featuresList.contains(name)) {
                  setState(() {
                    _featuresList.insert(0, name);
                  });
                  setModalState(() {
                    tempSelected.add(name);
                  });
                }
                Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Add",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  // ================= 3. IMAGE GALLERY CARD =================
  Widget _buildImageGalleryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Drag & sort toggle and 0/20 badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel("Image gallery *"),
              Row(
                children: [
                  Switch(
                    value: _dragAndSortEnabled,
                    activeThumbColor: const Color(0xFF003366),
                    onChanged: (val) {
                      setState(() => _dragAndSortEnabled = val);
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Drag & sort",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${_uploadedImages.length}/20",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Upload Box (Dashed / Bordered Area)
          InkWell(
            onTap: _addMockImage,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 28,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Drag & drop or click to upload",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "JPG, PNG or WebP Â· up to 20 photos",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Display uploaded image thumbnails if any
          if (_uploadedImages.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_uploadedImages.length, (idx) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image,
                          color: Color(0xFF64748B), size: 28),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _uploadedImages.removeAt(idx);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  // ================= 3. SEO & METADATA CARD =================
  Widget _buildSeoMetadataCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _seoMetadataExpanded = !_seoMetadataExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SEO & metadata",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Icon(
                    _seoMetadataExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          if (_seoMetadataExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SEO meta title (Image 2)
                  _buildLabel("SEO meta title"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _metaTitleCtrl,
                    hintText: "Enter SEO-friendly page title",
                  ),
                  const SizedBox(height: 14),

                  // 2. Permanent URL slug (Image 2)
                  _buildLabel("Permanent URL slug"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _permanentUrlSlugCtrl,
                    hintText: "caruid979",
                  ),
                  const SizedBox(height: 14),

                  // 3. Keywords (Image 2)
                  _buildLabel("Keywords"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _metaKeywordsCtrl,
                    hintText: "Type and press Enter...",
                  ),
                  const SizedBox(height: 14),

                  // 4. Meta description (Image 2)
                  _buildLabel("Meta description"),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _metaDescriptionCtrl,
                    maxLines: 4,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter meta description",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(12),
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
                        borderSide: const BorderSide(
                            color: Color(0xFF003366), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= HELPER UI BUILDERS =================
  Widget _buildResponsiveRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > 580) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .map((child) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: child,
                      ),
                    ))
                .toList(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: child,
                    ))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildFlexibleField({
    required String label,
    required Widget child,
    Color? labelColor,
    int flex = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, color: labelColor),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildLabel(String text, {Color? color}) {
    final isRequired = text.contains("*");
    final cleanText = text.replaceAll("*", "").trim();

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: cleanText,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? const Color(0xFF334155),
            ),
          ),
          if (isRequired)
            TextSpan(
              text: " *",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF94A3B8),
        ),
        suffixText: suffixText,
        suffixStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF94A3B8),
        ),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: Color(0xFF64748B),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF64748B)),
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: const Color(0xFF0F172A),
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: item.startsWith("Select")
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  _DashedRectPainter({
    this.color = const Color(0xFFCBD5E1),
    this.strokeWidth = 1.2,
    this.dash = 5,
    this.gap = 3,
    this.radius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len =
            (distance + dash < metric.length) ? dash : metric.length - distance;
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CarIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final blackFill = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final wheelRadius = h * 0.22;
    final wheelY = h * 0.78;
    final frontWheelX = w * 0.72;
    final rearWheelX = w * 0.28;

    final body = Path();
    body.moveTo(w * 0.12, wheelY);
    body.cubicTo(w * 0.08, h * 0.55, w * 0.16, h * 0.40, w * 0.32, h * 0.28);
    body.cubicTo(w * 0.42, h * 0.15, w * 0.58, h * 0.15, w * 0.70, h * 0.30);
    body.cubicTo(w * 0.82, h * 0.42, w * 0.94, h * 0.55, w * 0.90, wheelY);
    body.lineTo(frontWheelX + wheelRadius + 2, wheelY);
    body.arcToPoint(
      Offset(frontWheelX - wheelRadius - 2, wheelY),
      radius: Radius.circular(wheelRadius + 2),
      clockwise: false,
    );
    body.lineTo(rearWheelX + wheelRadius + 2, wheelY);
    body.arcToPoint(
      Offset(rearWheelX - wheelRadius - 2, wheelY),
      radius: Radius.circular(wheelRadius + 2),
      clockwise: false,
    );
    body.close();

    canvas.drawPath(body, fillPaint);
    canvas.drawPath(body, strokePaint);

    // Front window
    final frontWindow = Path();
    frontWindow.moveTo(w * 0.52, h * 0.24);
    frontWindow.lineTo(w * 0.65, h * 0.34);
    frontWindow.cubicTo(
        w * 0.68, h * 0.48, w * 0.64, h * 0.50, w * 0.52, h * 0.50);
    frontWindow.close();
    canvas.drawPath(frontWindow, blackFill);

    // Rear window
    final rearWindow = Path();
    rearWindow.moveTo(w * 0.48, h * 0.24);
    rearWindow.cubicTo(
        w * 0.36, h * 0.30, w * 0.30, h * 0.42, w * 0.32, h * 0.50);
    rearWindow.lineTo(w * 0.48, h * 0.50);
    rearWindow.close();
    canvas.drawPath(rearWindow, blackFill);

    // Door handle
    final handlePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(w * 0.50, h * 0.57), width: 10, height: 4),
        const Radius.circular(2),
      ),
      handlePaint,
    );

    // Headlight detail
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(w * 0.83, h * 0.54), width: 10, height: 14),
      -1.5,
      3.0,
      false,
      strokePaint,
    );

    // Wheels
    for (final wx in [rearWheelX, frontWheelX]) {
      canvas.drawCircle(Offset(wx, wheelY), wheelRadius, blackFill);
      canvas.drawCircle(Offset(wx, wheelY), wheelRadius * 0.45, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
