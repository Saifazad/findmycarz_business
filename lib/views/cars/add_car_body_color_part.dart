part of 'add_car_screen.dart';

extension _AddCarBodyColorPart on _AddCarScreenState {
  // ================= BODY TYPE CARD (IMAGE 1) =================
  Widget _buildBodyTypeCard() {
    final search = _bodyTypeSearchCtrl.text.trim().toLowerCase();
    final filtered =
        _bodyTypes.where((b) => b.toLowerCase().contains(search)).toList();

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
                _bodyTypeExpanded = !_bodyTypeExpanded;
              });
            },
            onLongPress: _showBodyTypePicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Body Type",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (!_bodyTypeExpanded && _selectedBodyType != "Select") ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedBodyType,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _bodyTypeExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_bodyTypeExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find body type...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _bodyTypeSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find body type...",
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

            // List of Body Types
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No body type found",
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
                        final bt = filtered[i];
                        final isSelected = _selectedBodyType == bt;
                        return _buildBodyTypeRowItem(bt, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Body Type
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingBodyType = !_isAddingBodyType;
                });
              },
              onLongPress: _showAddBodyTypeDialog,
              borderRadius: _isAddingBodyType
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingBodyType
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Body Type",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Body Type Form (Matching Image)
            if (_isAddingBodyType) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Body Type ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Body Type Image",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container for image
                    _buildDashedBorderContainer(
                      onTap: () {
                        setState(() {
                          if (_newBodyTypeImageMock == null) {
                            _newBodyTypeImageMock = "body_type.png";
                          } else {
                            _newBodyTypeImageMock = null;
                          }
                        });
                      },
                      child: _newBodyTypeImageMock == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 26,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "No file chosen",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF14B8A6),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Image selected",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Body Type Name",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newBodyTypeNameCtrl,
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
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewBodyType(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewBodyType,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingBodyType = false;
                              _newBodyTypeNameCtrl.clear();
                              _newBodyTypeImageMock = null;
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
                              fontWeight: FontWeight.bold,
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

  void _saveNewBodyType() {
    final val = _newBodyTypeNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        if (!_bodyTypes.contains(val)) {
          _bodyTypes.insert(0, val);
        }
        _selectedBodyType = val;
        _isAddingBodyType = false;
        _newBodyTypeNameCtrl.clear();
        _newBodyTypeImageMock = null;
      });
    }
  }

  Widget _buildBodyTypeRowItem(
    String bt,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenBodyTypes.contains(bt);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedBodyType = bt;
            });
            onStateChange?.call();
          },
      child: Container(
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF2563EB), width: 3.5),
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 10.5 : 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF10B981)
                  : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 12),

            // Car icon badge
            Container(
              width: 38,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Icon(
                  Icons.directions_car_rounded,
                  size: 16,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Body Type name
            Expanded(
              child: Text(
                bt,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle hide
                  if (_hiddenBodyTypes.contains(bt)) {
                    _hiddenBodyTypes.remove(bt);
                  } else {
                    _hiddenBodyTypes.add(bt);
                  }
                  // Also select this body type
                  _selectedBodyType = bt;
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

            // Action 2: Edit
            InkWell(
              onTap: () {
                setState(() {
                  _selectedBodyType = bt;
                });
                onStateChange?.call();
                _editBodyTypeDialog(bt, onUpdated: onStateChange);
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
              onTap: () => _deleteBodyTypeDialog(bt, onDeleted: onStateChange),
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

  void _editBodyTypeDialog(String bt, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: bt);
    bool hasImage = true;

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
                          "Edit Body Type ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Body Type Image",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container with car illustration or upload placeholder
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setDState(() {
                          hasImage = !hasImage;
                        });
                      },
                      child: hasImage
                          ? Stack(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: 120,
                                    height: 56,
                                    child: CustomPaint(
                                      painter: CarIllustrationPainter(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setDState(() {
                                        hasImage = false;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                  color: Color(0xFF818CF8),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "No file chosen",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Body Type Name",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: editCtrl,
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
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final newName = editCtrl.text.trim();
                            if (newName.isNotEmpty) {
                              setState(() {
                                final idx = _bodyTypes.indexOf(bt);
                                if (idx != -1) {
                                  _bodyTypes[idx] = newName;
                                }
                                if (_selectedBodyType == bt) {
                                  _selectedBodyType = newName;
                                }
                                if (_hiddenBodyTypes.contains(bt)) {
                                  _hiddenBodyTypes.remove(bt);
                                  _hiddenBodyTypes.add(newName);
                                }
                              });
                              onUpdated?.call();
                            }
                            Navigator.pop(ctx);
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
                              fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
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

  void _deleteBodyTypeDialog(String bt, {VoidCallback? onDeleted}) {
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
                "Delete Body Type",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$bt\"? This action cannot be undone.",
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
                  _bodyTypes.remove(bt);
                  if (_selectedBodyType == bt) {
                    _selectedBodyType = "Select";
                  }
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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

  void _showAddBodyTypeDialog({VoidCallback? onAdded}) {
    final addCtrl = TextEditingController();
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
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Color(0xFF059669), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Add Body Type",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Body Type Name *",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: addCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "e.g. CONVERTIBLE, VAN...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
              ),
            ],
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
                final val = addCtrl.text.trim();
                if (val.isNotEmpty && !_bodyTypes.contains(val)) {
                  setState(() {
                    _bodyTypes.insert(0, val);
                    _selectedBodyType = val;
                  });
                  onAdded?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= EXTERIOR COLOR CARD (IMAGE 2) =================
  Widget _buildExteriorColorCard() {
    final search = _exteriorColorSearchCtrl.text.trim().toLowerCase();
    final filtered = _exteriorColors.where((item) {
      final name = (item["name"] as String).toLowerCase();
      return name.contains(search);
    }).toList();

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
                _exteriorColorExpanded = !_exteriorColorExpanded;
              });
            },
            onLongPress: _showColorPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.palette_outlined,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Exterior Color",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: " *",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_exteriorColorExpanded &&
                      _selectedExteriorColor != "Select") ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedExteriorColor,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _exteriorColorExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_exteriorColorExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find color...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _exteriorColorSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find color...",
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

            // List of Exterior Colors
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No color found",
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
                        );
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Color
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingExteriorColor = !_isAddingExteriorColor;
                });
              },
              onLongPress: _showAddExteriorColorDialog,
              borderRadius: _isAddingExteriorColor
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingExteriorColor
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Color",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Color Form (Matching Image: media_1795420672799_121eec9c.png)
            if (_isAddingExteriorColor) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Color ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Color Swatch (Image)",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setState(() {
                          if (_newExteriorColorImageMock == null) {
                            _newExteriorColorImageMock = "swatch.png";
                          } else {
                            _newExteriorColorImageMock = null;
                          }
                        });
                      },
                      child: _newExteriorColorImageMock == null
                          ? const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: Color(0xFF818CF8),
                              ),
                            )
                          : Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: _parseHexColor(
                                          _newExteriorColorCodeCtrl.text
                                              .trim()),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _newExteriorColorImageMock = null;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Color Code",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.colorize_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newExteriorColorCodeCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "#000000",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Color Name",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newExteriorColorNameCtrl,
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
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewExteriorColor(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewExteriorColor,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingExteriorColor = false;
                              _newExteriorColorNameCtrl.clear();
                              _newExteriorColorCodeCtrl.text = "#000000";
                              _newExteriorColorImageMock = null;
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
                              fontWeight: FontWeight.bold,
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

  void _saveNewExteriorColor() {
    final name = _newExteriorColorNameCtrl.text.trim();
    final code = _newExteriorColorCodeCtrl.text.trim();
    if (name.isNotEmpty) {
      final parsedColor = _parseHexColor(code.isNotEmpty ? code : "#000000");
      setState(() {
        final exists = _exteriorColors.any(
            (c) => (c["name"] as String).toLowerCase() == name.toLowerCase());
        if (!exists) {
          _exteriorColors.insert(0, {
            "name": name,
            "code": code.isNotEmpty ? code : "#000000",
            "color": parsedColor,
            "border": parsedColor == Colors.white,
          });
        }
        _selectedExteriorColor = name;
        _isAddingExteriorColor = false;
        _newExteriorColorNameCtrl.clear();
        _newExteriorColorCodeCtrl.text = "#000000";
        _newExteriorColorImageMock = null;
      });
    }
  }

  Widget _buildExteriorColorRowItem(
    String name,
    Color color,
    bool border,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenExteriorColors.contains(name);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedExteriorColor = name;
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF10B981)
                  : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 12),

            // Color circle
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: border ? const Color(0xFFCBD5E1) : color,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Color name
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle hide
                  if (_hiddenExteriorColors.contains(name)) {
                    _hiddenExteriorColors.remove(name);
                  } else {
                    _hiddenExteriorColors.add(name);
                  }
                  // Also select this exterior color
                  _selectedExteriorColor = name;
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

            // Action 2: Edit
            InkWell(
              onTap: () {
                setState(() {
                  _selectedExteriorColor = name;
                });
                onStateChange?.call();
                _editExteriorColorDialog(name, onUpdated: onStateChange);
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
                  _deleteExteriorColorDialog(name, onDeleted: onStateChange),
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

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll("#", "").trim();
      if (clean.length == 6) {
        return Color(int.parse("0xFF$clean"));
      } else if (clean.length == 8) {
        return Color(int.parse("0x$clean"));
      }
    } catch (_) {}
    return const Color(0xFF1E293B);
  }

  void _editExteriorColorDialog(String name, {VoidCallback? onUpdated}) {
    final existing = _exteriorColors.firstWhere(
      (c) => c["name"] == name,
      orElse: () => {"name": name, "color": const Color(0xFF000000)},
    );
    final existingColor =
        (existing["color"] as Color?) ?? const Color(0xFF000000);
    final initialCode = (existing["code"] as String?) ??
        '#${existingColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final codeCtrl = TextEditingController(text: initialCode);
    final nameCtrl = TextEditingController(text: name);
    bool hasImage = false;

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
                          "Edit Color ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Color Swatch (Image)",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setDState(() {
                          hasImage = !hasImage;
                        });
                      },
                      child: hasImage
                          ? Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          _parseHexColor(codeCtrl.text.trim()),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setDState(() {
                                        hasImage = false;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: Color(0xFF818CF8),
                              ),
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Color Code",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.colorize_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: codeCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "#000000",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Color Name",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: nameCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Color Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final newName = nameCtrl.text.trim();
                            final newCode = codeCtrl.text.trim();
                            if (newName.isNotEmpty) {
                              setState(() {
                                for (var c in _exteriorColors) {
                                  if (c["name"] == name) {
                                    c["name"] = newName;
                                    if (newCode.isNotEmpty) {
                                      c["code"] = newCode;
                                      c["color"] = _parseHexColor(newCode);
                                    }
                                    break;
                                  }
                                }
                                if (_selectedExteriorColor == name) {
                                  _selectedExteriorColor = newName;
                                }
                                if (_hiddenExteriorColors.contains(name)) {
                                  _hiddenExteriorColors.remove(name);
                                  _hiddenExteriorColors.add(newName);
                                }
                              });
                              onUpdated?.call();
                            }
                            Navigator.pop(ctx);
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
                              fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
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

  void _deleteExteriorColorDialog(String name, {VoidCallback? onDeleted}) {
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
                "Delete Exterior Color",
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
                  _exteriorColors.removeWhere((c) => c["name"] == name);
                  if (_selectedExteriorColor == name) {
                    _selectedExteriorColor = "Select";
                  }
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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

  void _showAddExteriorColorDialog({VoidCallback? onAdded}) {
    final addCtrl = TextEditingController();
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
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Color(0xFF059669), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Add Exterior Color",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Color Name *",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: addCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "e.g. Bronze, Maroon...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
              ),
            ],
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
                final val = addCtrl.text.trim();
                if (val.isNotEmpty) {
                  final exists = _exteriorColors.any((c) =>
                      (c["name"] as String).toLowerCase() == val.toLowerCase());
                  if (!exists) {
                    setState(() {
                      _exteriorColors.insert(0, {
                        "name": val,
                        "color": const Color(0xFF94A3B8),
                        "border": false,
                      });
                      _selectedExteriorColor = val;
                    });
                    onAdded?.call();
                  }
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveDraft() {
    setState(() {
      _publishingStatus = "Draft";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vehicle saved as Draft successfully!"),
        backgroundColor: Color(0xFF4F46E5),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showVehiclePreview() {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.preview_rounded,
                    color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Vehicle Preview",
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
                _carNameCtrl.text.isNotEmpty
                    ? _carNameCtrl.text
                    : "${_selectedManufacturer != 'Select' ? _selectedManufacturer : ''} ${_selectedModel != 'Select manufacturer first' ? _selectedModel : 'Vehicle Listing'}",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "UID: ${widget.carUid} â€¢ Status: $_publishingStatus",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Asking Price: â‚¹${_askingPriceCtrl.text.isNotEmpty ? _askingPriceCtrl.text : 'N/A'}",
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Location: $_location â€¢ Homepage: $_homepageVisibility",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Features: ${_selectedFeatures.isNotEmpty ? _selectedFeatures.length : 0} selected â€¢ Photos: ${_uploadedImages.length}/20",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPublishingStatusPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Close 'X' (Image 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Publishing Status",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: const Color(0xFF0F172A),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

              // Options: Published, Draft, Under Review, Archived (Image 1)
              ..._publishingOptions.map((item) {
                final isSelected = _publishingStatus == item;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _publishingStatus = item;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                size: 20,
                                color: Color(0xFF2563EB),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPicker() {
    final locations = [
      "Dehradun (UK-07)",
      "Delhi NCR",
      "Haridwar (UK-08)",
      "Rishikesh (UK-14)",
      "Noida (UP-16)",
      "Gurgaon (HR-26)",
      "Chandigarh",
    ];

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
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Location",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: locations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final loc = locations[i];
                    final isSelected = _location == loc;
                    return ListTile(
                      title: Text(
                        loc,
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
                        setState(() => _location = loc);
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

  void _showHomepagePicker() {
    final options = ["Show", "Hide"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Homepage Visibility",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              ...options.map((opt) {
                final isSelected = _homepageVisibility == opt;
                return ListTile(
                  title: Text(
                    opt == "Show"
                        ? "Show (Visible on homepage)"
                        : "Hide (Hidden from homepage)",
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
                      ? const Icon(Icons.check_circle, color: Color(0xFF2563EB))
                      : null,
                  onTap: () {
                    setState(() => _homepageVisibility = opt);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSchedulePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Publishing Schedule",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              ListTile(
                title: Text(
                  "Immediately",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: _scheduleOption == "Immediately"
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: _scheduleOption == "Immediately"
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF0F172A),
                  ),
                ),
                trailing: _scheduleOption == "Immediately"
                    ? const Icon(Icons.check_circle, color: Color(0xFF2563EB))
                    : null,
                onTap: () {
                  setState(() => _scheduleOption = "Immediately");
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(
                  "Pick Custom Date & Time",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: _scheduleOption != "Immediately"
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: _scheduleOption != "Immediately"
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF0F172A),
                  ),
                ),
                trailing: const Icon(Icons.calendar_month_outlined,
                    color: Color(0xFF64748B)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _scheduleOption =
                          DateFormat('dd MMM yyyy').format(picked);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
