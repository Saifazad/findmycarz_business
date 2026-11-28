import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'blogs_screen.dart';

class EditBlogScreen extends StatefulWidget {
  final BlogItem blog;
  final bool isAdd;

  const EditBlogScreen({
    super.key,
    required this.blog,
    this.isAdd = false,
  });

  @override
  State<EditBlogScreen> createState() => _EditBlogScreenState();
}

class _GalleryMediaItem {
  final String path;
  final bool isVideo = false;

  _GalleryMediaItem({required this.path});
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;

  late TextEditingController _titleCtrl;
  late TextEditingController _writerCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imagePathCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _publishDateCtrl;
  late List<_GalleryMediaItem> _mediaGallery;
  String _publishingStatus = "Active";
  String _visibility = "Public";
  String _publishDateStr = "2026-09-01 14:26";
  late String _tempStatus;
  late String _tempVisibility;
  bool _isEditingStatus = false;
  bool _isEditingVisibility = false;
  bool _isEditingPublishDate = false;

  final List<String> _stepTitles = ["Details", "Media", "Publish"];
  final List<String> _stepSubtitles = [
    "Title, writer, description",
    "Featured image and media",
    "Status, schedule and review",
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.blog.title);
    _writerCtrl = TextEditingController(text: widget.blog.author);
    _descCtrl = TextEditingController(
      text: widget.blog.description ??
          "Festivals are coming... Godowns must be filled with adequate stock to meet high customer demand during the upcoming festive season.",
    );
    _imagePathCtrl = TextEditingController(text: widget.blog.imagePath ?? "");
    _dateCtrl = TextEditingController(text: widget.blog.date);
    _publishingStatus = widget.blog.isActive ? "Active" : "Draft";
    _visibility = "Public";
    _publishDateStr = "2026-09-01 14:26";
    _tempStatus = _publishingStatus;
    _tempVisibility = _visibility;
    _publishDateCtrl = TextEditingController(text: _publishDateStr);
    _mediaGallery = (widget.blog.imagePath != null &&
            widget.blog.imagePath!.trim().isNotEmpty)
        ? [_GalleryMediaItem(path: widget.blog.imagePath!)]
        : [];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleCtrl.dispose();
    _writerCtrl.dispose();
    _descCtrl.dispose();
    _imagePathCtrl.dispose();
    _dateCtrl.dispose();
    _publishDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null || !mounted) return;
      setState(() {
        _imagePathCtrl.text = file.path;
      });
    } catch (_) {}
  }

  Future<void> _pickGalleryImages() async {
    try {
      final picker = ImagePicker();
      final files = await picker.pickMultiImage();
      if (files.isEmpty || !mounted) return;
      setState(() {
        for (final f in files) {
          _mediaGallery.add(_GalleryMediaItem(path: f.path));
        }
      });
    } catch (_) {}
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_titleCtrl.text.trim().isEmpty) {
        _showError("Title is required");
        return;
      }
      if (_writerCtrl.text.trim().isEmpty) {
        _showError("Writer is required");
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _scrollToTop();
    } else {
      _saveBlog();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _scrollToTop();
    } else {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(message, style: GoogleFonts.poppins(fontSize: 12.5)),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveBlog() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      _showError("Title is required");
      return;
    }

    widget.blog.title = title;
    widget.blog.author =
        _writerCtrl.text.trim().isEmpty ? "Admin" : _writerCtrl.text.trim();
    widget.blog.description = _descCtrl.text.trim();
    widget.blog.imagePath = _imagePathCtrl.text.trim().isNotEmpty
        ? _imagePathCtrl.text.trim()
        : null;
    widget.blog.isActive = _publishingStatus == "Active";
    widget.blog.date = _publishDateStr;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.isAdd
                    ? "Blog added successfully!"
                    : "Blog updated successfully!",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : AppColors.background,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          elevation: 0.5,
          leading: CustomBackButton(
            isDarkMode: isDark,
            onPressed: () {
              if (_currentStep > 0) {
                _previousStep();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            widget.isAdd ? "Add Blog" : "Edit Blog",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          actions: const [
            AdminProfileAvatar(),
            SizedBox(width: 14),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ================= 1. HEADER BANNER (ROYAL BLUE GRADIENT) =================
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isAdd
                                ? "Add New Blog"
                                : "Edit Blog",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _stepSubtitles[_currentStep],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= 2. STEPPER ROW (3 STEPS: Details, Media, Publish) =================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (index) {
                          final isCurrent = index == _currentStep;
                          final isPassed = index < _currentStep;

                          return InkWell(
                            onTap: () {
                              setState(() => _currentStep = index);
                              _scrollToTop();
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isPassed
                                          ? AppColors.success
                                          : (isCurrent
                                              ? AppColors.primary
                                              : (isDark
                                                  ? const Color(0xFF1E293B)
                                                  : AppColors.stepInactiveBg)),
                                      border: Border.all(
                                        color: isPassed
                                            ? AppColors.success
                                            : (isCurrent
                                                ? AppColors.primary
                                                : (isDark
                                                    ? const Color(0xFF334155)
                                                    : AppColors.stepInactiveBorder)),
                                        width: isCurrent ? 2 : 1,
                                      ),
                                      boxShadow: isCurrent
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.25),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: isPassed
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "${index + 1}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: (isCurrent || isPassed)
                                                    ? Colors.white
                                                    : (isDark
                                                        ? Colors.grey.shade400
                                                        : AppColors.stepInactiveText),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _stepTitles[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: isCurrent
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isCurrent
                                          ? (isDark
                                              ? Colors.white
                                              : AppColors.primary)
                                          : (isPassed
                                              ? AppColors.success
                                              : (isDark
                                                  ? Colors.grey.shade400
                                                  : AppColors.stepInactiveText)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),

                    // ================= 3. SCROLLABLE FORM BODY =================
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(18),
                        child: _buildCurrentStepContent(isDark),
                      ),
                    ),

                    // ================= 4. BOTTOM ACTION BUTTONS =================
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF131B2E) : Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (_currentStep > 0) ...[
                            // Back Button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _previousStep,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  foregroundColor: AppColors.primary,
                                  backgroundColor: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                          ],

                          // Next / Update Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: Text(
                                _currentStep == 2
                                    ? (widget.isAdd
                                        ? "Save Blog"
                                        : "Update Blog")
                                    : "Next",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
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
            ),
          ),
        ),
      ),
    );
  }

  // ================= STEP SWITCHER =================
  Widget _buildCurrentStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildDetailsStep(isDark);
      case 1:
        return _buildMediaStep(isDark);
      case 2:
        return _buildPublishStep(isDark);
      default:
        return const SizedBox();
    }
  }

  // ================= STEP 1: DETAILS =================
  Widget _buildDetailsStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Blog details"),
        const SizedBox(height: 14),

        _buildFormField(
          label: "Title",
          controller: _titleCtrl,
          hint: "Enter blog title...",
          isRequired: true,
        ),
        const SizedBox(height: 14),

        _buildFormField(
          label: "Writer",
          controller: _writerCtrl,
          hint: "Enter writer name...",
          isRequired: true,
        ),
        const SizedBox(height: 14),

        _buildFormField(
          label: "Description",
          controller: _descCtrl,
          hint: "Write the blog here",
          isRequired: true,
          maxLines: 7,
          minLines: 5,
        ),
      ],
    );
  }

  // ================= STEP 2: MEDIA =================
  Widget _buildMediaStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Media & Images"),
        const SizedBox(height: 14),

        // 1. Media Gallery Card (On Top)
        _buildMediaGalleryCard(isDark),
        const SizedBox(height: 16),

        // 2. Cover Image Card (Below Media Gallery)
        _buildCoverImageCard(isDark),
      ],
    );
  }

  Widget _buildCoverImagePreview(String path, bool isDark) {
    Widget fallback() => Container(
          height: 130,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 36,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
              const SizedBox(height: 6),
              Text(
                path,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );

    if (path.startsWith('http')) {
      return Image.network(
        path,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }
    return Image.file(
      File(path),
      height: 130,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }

  // ================= COVER IMAGE CARD =================
  Widget _buildCoverImageCard(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Cover Image"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              "Cover Image",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),

          // Body: Dashed Box or Selected Image Preview
          Padding(
            padding: const EdgeInsets.all(16),
            child: _imagePathCtrl.text.isNotEmpty
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildCoverImagePreview(_imagePathCtrl.text, isDark),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _imagePathCtrl.clear();
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFEF4444),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: _pickCoverImage,
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: _DashedRectPainter(
                        color: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1),
                        dash: 5,
                        gap: 4,
                        radius: 8,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        alignment: Alignment.center,
                        child: Text(
                          "Drag & drop or click to upload",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey.shade400
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ================= MEDIA GALLERY CARD =================
  Widget _buildMediaGalleryCard(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + "Media Gallery" + Green count badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.photo_library_outlined,
                  size: 19,
                  color: Color(0xFF14B8A6),
                ),
                const SizedBox(width: 8),
                Text(
                  "Media Gallery",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${_mediaGallery.length}",
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dashed border container enclosing thumbnails
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: CustomPaint(
              painter: _DashedRectPainter(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
                dash: 5,
                gap: 4,
                radius: 8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: _mediaGallery.isEmpty
                    ? InkWell(
                        onTap: _pickGalleryImages,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 110,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Drag & drop or click to add media",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Mobile layout: 2 or 3 columns based on width
                          final cols = constraints.maxWidth > 340 ? 3 : 2;
                          const spacing = 8.0;
                          final itemWidth =
                              (constraints.maxWidth - (cols - 1) * spacing) /
                                  cols;
                          final itemHeight = itemWidth * 0.62;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children:
                                List.generate(_mediaGallery.length, (idx) {
                              final item = _mediaGallery[idx];
                              return SizedBox(
                                width: itemWidth,
                                height: itemHeight,
                                child: Stack(
                                  clipBehavior: Clip.antiAlias,
                                  children: [
                                    // Image Thumbnail
                                    Container(
                                      width: itemWidth,
                                      height: itemHeight,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E293B),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          item.path.startsWith('http')
                                              ? Image.network(
                                                  item.path,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                    color:
                                                        const Color(0xFF1E293B),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      item.isVideo
                                                          ? Icons
                                                              .videocam_outlined
                                                          : Icons
                                                              .image_outlined,
                                                      color: Colors.white54,
                                                      size: 20,
                                                    ),
                                                  ),
                                                )
                                              : (item.path.startsWith('assets/')
                                                  ? Image.asset(
                                                      item.path,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              Container(
                                                        color: const Color(
                                                            0xFF1E293B),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          item.isVideo
                                                              ? Icons
                                                                  .videocam_outlined
                                                              : Icons
                                                                  .image_outlined,
                                                          color: Colors.white54,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    )
                                                  : Image.file(
                                                      File(item.path),
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              Container(
                                                        color: const Color(
                                                            0xFF1E293B),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          item.isVideo
                                                              ? Icons
                                                                  .videocam_outlined
                                                              : Icons
                                                                  .image_outlined,
                                                          color: Colors.white54,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    )),
                                          if (item.isVideo)
                                            Container(
                                              color: Colors.black.withValues(
                                                  alpha: 0.25),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Video Play Icon in Center
                                    if (item.isVideo)
                                      Positioned.fill(
                                        child: Center(
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                  alpha: 0.45),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                    alpha: 0.8),
                                                width: 1,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.play_arrow,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Close / Delete Red Badge Button in Top Right
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _mediaGallery.removeAt(idx);
                                          });
                                        },
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.close,
                                            size: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= STEP 3: PUBLISH =================
  Widget _buildPublishStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPublishCard(isDark),
      ],
    );
  }

  // ================= PUBLISH CARD (MATCHING REFERENCE DESIGN) =================
  Widget _buildPublishCard(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Publish"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              "Publish",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),

          // Top Action Buttons: Save Draft & Preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _publishingStatus = "Draft";
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text("Saved as Draft",
                                style: GoogleFonts.poppins(fontSize: 12.5)),
                          ],
                        ),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Save Draft",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _showPreviewDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF94A3B8),
                    side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Preview",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),

          // Metadata Detail Rows: Status, Visibility, Publish
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Row 1: Status
                Row(
                  children: [
                    Icon(
                      Icons.vpn_key_outlined,
                      size: 16,
                      color: isDark
                          ? Colors.white60
                          : AppColors.inputIcon,
                    ),
                    const SizedBox(width: 10),
                    Text.rich(
                      TextSpan(
                        text: "Status: ",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF475569),
                        ),
                        children: [
                          TextSpan(
                            text: _publishingStatus,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _tempStatus = _publishingStatus;
                          _isEditingStatus = !_isEditingStatus;
                          _isEditingVisibility = false;
                          _isEditingPublishDate = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          "Edit",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isEditingStatus) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: ["Active", "Draft", "Inactive"]
                            .contains(_tempStatus)
                        ? _tempStatus
                        : "Active",
                    dropdownColor:
                        isDark ? const Color(0xFF1E293B) : Colors.white,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor:
                          isDark ? const Color(0xFF0F172A) : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: ["Active", "Draft", "Inactive"].map((s) {
                      return DropdownMenuItem<String>(
                        value: s,
                        child: Text(s),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _tempStatus = val);
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _publishingStatus = _tempStatus;
                            _isEditingStatus = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            "OK",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          setState(() => _isEditingStatus = false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),

                // Row 2: Visibility
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: isDark
                          ? Colors.white60
                          : AppColors.inputIcon,
                    ),
                    const SizedBox(width: 10),
                    Text.rich(
                      TextSpan(
                        text: "Visibility: ",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF475569),
                        ),
                        children: [
                          TextSpan(
                            text: _visibility,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _tempVisibility = _visibility;
                          _isEditingVisibility = !_isEditingVisibility;
                          _isEditingStatus = false;
                          _isEditingPublishDate = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          "Edit",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isEditingVisibility) ...[
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: _tempVisibility,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _tempVisibility = val);
                      }
                    },
                    child: Column(
                      children: ["Public", "Private"].map((v) {
                        return InkWell(
                          onTap: () {
                            setState(() => _tempVisibility = v);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Radio<String>(
                                    value: v,
                                    activeColor: AppColors.primary,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  v,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _visibility = _tempVisibility;
                            _isEditingVisibility = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            "OK",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          setState(() => _isEditingVisibility = false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),

                // Row 3: Publish
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: isDark
                          ? Colors.white60
                          : AppColors.inputIcon,
                    ),
                    const SizedBox(width: 10),
                    Text.rich(
                      TextSpan(
                        text: "Publish: ",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF475569),
                        ),
                        children: [
                          TextSpan(
                            text: _publishDateStr,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _publishDateCtrl.text = _publishDateStr;
                          _isEditingPublishDate = !_isEditingPublishDate;
                          _isEditingStatus = false;
                          _isEditingVisibility = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          "Edit",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isEditingPublishDate) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: _publishDateCtrl,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "YYYY-MM-DD HH:MM",
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: AppColors.inputIcon,
                        ),
                        onPressed: _pickPublishDateTime,
                      ),
                      filled: true,
                      fillColor:
                          isDark ? const Color(0xFF0F172A) : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            final val = _publishDateCtrl.text.trim();
                            if (val.isNotEmpty) {
                              _publishDateStr = val;
                              _dateCtrl.text = val;
                            }
                            _isEditingPublishDate = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            "OK",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          setState(() => _isEditingPublishDate = false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPublishDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (!mounted) return;

    final time = pickedTime ?? const TimeOfDay(hour: 14, minute: 26);
    final y = pickedDate.year.toString().padLeft(4, '0');
    final m = pickedDate.month.toString().padLeft(2, '0');
    final d = pickedDate.day.toString().padLeft(2, '0');
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');

    setState(() {
      _publishDateCtrl.text = "$y-$m-$d $hh:$mm";
    });
  }

  void _showPreviewDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Blog Preview",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_imagePathCtrl.text.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    _imagePathCtrl.text,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                _titleCtrl.text.isNotEmpty ? _titleCtrl.text : "Untitled Blog",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "By ${_writerCtrl.text.isNotEmpty ? _writerCtrl.text : 'Admin'} · $_publishDateStr · $_visibility",
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _descCtrl.text,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= FORM HELPER WIDGETS =================
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isRequired = false,
    int minLines = 1,
    int maxLines = 1,
    IconData? suffixIcon,
    ValueChanged<String>? onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
            if (isRequired)
              Text(
                " *",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFEF4444),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          onChanged: onChanged,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 12.5,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: AppColors.inputIcon)
                : null,
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double gap;
  final double dash;
  final double radius;
  static const double strokeWidth = 1.2;

  _DashedRectPainter({
    this.color = const Color(0xFFCBD5E1),
    this.dash = 5,
    this.gap = 4,
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

    for (final metric in path.computeMetrics()) {
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
