import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'testimonials_screen.dart';

class EditTestimonialScreen extends StatefulWidget {
  final TestimonialItem testimonial;
  final bool isAdd;

  const EditTestimonialScreen({
    super.key,
    required this.testimonial,
    this.isAdd = false,
  });

  @override
  State<EditTestimonialScreen> createState() => _EditTestimonialScreenState();
}

class _EditTestimonialScreenState extends State<EditTestimonialScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;

  late TextEditingController _nameCtrl;
  late TextEditingController _designationCtrl;
  late TextEditingController _feedbackCtrl;
  late TextEditingController _photoPathCtrl;
  late int _rating;
  late bool _isActive;

  final List<String> _stepTitles = ["Feedback", "Photo & Publish"];
  final List<String> _stepSubtitles = [
    "Client and review",
    "Client photo and publish settings",
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.testimonial.name);
    _designationCtrl =
        TextEditingController(text: widget.testimonial.designation ?? "");
    _feedbackCtrl = TextEditingController(text: widget.testimonial.feedback);
    _photoPathCtrl =
        TextEditingController(text: widget.testimonial.photoPath ?? "");
    _rating = widget.testimonial.rating > 0 ? widget.testimonial.rating : 5;
    _isActive = widget.testimonial.isActive;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _designationCtrl.dispose();
    _feedbackCtrl.dispose();
    _photoPathCtrl.dispose();
    super.dispose();
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
      if (_nameCtrl.text.trim().isEmpty) {
        _showError("Client name is required");
        return;
      }
      if (_feedbackCtrl.text.trim().isEmpty) {
        _showError("Review / feedback is required");
        return;
      }
    }

    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _scrollToTop();
    } else {
      _saveTestimonial();
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

  void _saveTestimonial() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showError("Client name is required");
      return;
    }

    widget.testimonial.name = name;
    widget.testimonial.designation = _designationCtrl.text.trim().isNotEmpty
        ? _designationCtrl.text.trim()
        : null;
    widget.testimonial.feedback = _feedbackCtrl.text.trim();
    widget.testimonial.rating = _rating;
    widget.testimonial.photoPath = _photoPathCtrl.text.trim().isNotEmpty
        ? _photoPathCtrl.text.trim()
        : null;
    widget.testimonial.isActive = _isActive;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.isAdd
                    ? "Testimonial added successfully!"
                    : "Testimonial updated successfully!",
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
            widget.isAdd ? "Add Testimonial" : "Edit Testimonial",
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
                    // ================= 1. HEADER BANNER (PURPLE GRADIENT) =================
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
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
                                ? "Add New Testimonial"
                                : "Edit Testimonial",
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

                    // ================= 2. STEPPER ROW (2 STEPS: Feedback, Photo & Publish) =================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(_stepTitles.length, (index) {
                          final isCurrent = index == _currentStep;
                          final isCompleted = index < _currentStep;

                          return Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted
                                        ? const Color(0xFF22C55E)
                                        : isCurrent
                                            ? const Color(0xFF6366F1)
                                            : (isDark
                                                ? const Color(0xFF1E293B)
                                                : const Color(0xFFF1F5F9)),
                                    border: Border.all(
                                      color: isCompleted
                                          ? const Color(0xFF22C55E)
                                          : isCurrent
                                              ? const Color(0xFF6366F1)
                                              : (isDark
                                                  ? const Color(0xFF334155)
                                                  : const Color(0xFFCBD5E1)),
                                      width: 1.5,
                                    ),
                                    boxShadow: isCurrent
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF6366F1)
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: isCompleted
                                      ? const Icon(Icons.check,
                                          size: 20, color: Colors.white)
                                      : Text(
                                          "${index + 1}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isCurrent
                                                ? Colors.white
                                                : (isDark
                                                    ? Colors.grey.shade400
                                                    : const Color(0xFF64748B)),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _stepTitles[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isCurrent
                                        ? const Color(0xFF10B981)
                                        : (isDark
                                            ? Colors.grey.shade400
                                            : const Color(0xFF64748B)),
                                  ),
                                ),
                              ],
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
                            // Back Button (Compact proportional width for mobile)
                            SizedBox(
                              width: 95,
                              child: OutlinedButton(
                                onPressed: _previousStep,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF22C55E),
                                    width: 1.2,
                                  ),
                                  foregroundColor: const Color(0xFF22C55E),
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
                                    color: const Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],

                          // Next / Update Button (Expanded with FittedBox for perfect mobile rendering)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A3FF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _currentStep == 1
                                      ? (widget.isAdd
                                          ? "Save Testimonial"
                                          : "Update Testimonial")
                                      : "Next",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
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
        return _buildFeedbackStep(isDark);
      case 1:
        return _buildPhotoAndPublishStep(isDark);
      default:
        return const SizedBox();
    }
  }

  // ================= STEP 1: FEEDBACK =================
  Widget _buildFeedbackStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Customer feedback"),
        const SizedBox(height: 14),

        // Client Name
        _buildFormField(
          label: "Client name",
          controller: _nameCtrl,
          hint: "Enter client name...",
          isRequired: true,
          prefixIcon: const Icon(Icons.person, color: Color(0xFF6366F1), size: 18),
        ),
        const SizedBox(height: 14),

        // Designation (Optional)
        _buildFormField(
          label: "Designation (Optional)",
          controller: _designationCtrl,
          hint: "e.g. CEO, Tech Inc.",
          isRequired: false,
          prefixIcon:
              const Icon(Icons.work_outline, color: Color(0xFF8B5CF6), size: 18),
        ),
        const SizedBox(height: 14),

        // Rating *
        Row(
          children: [
            Text(
              "Rating",
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              "*",
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(5, (idx) {
            final starNum = idx + 1;
            final isFilled = starNum <= _rating;
            return InkWell(
              onTap: () {
                setState(() {
                  _rating = starNum;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: const Color(0xFFF59E0B),
                  size: 32,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),

        // Review / Feedback
        _buildFormField(
          label: "Review / Feedback",
          controller: _feedbackCtrl,
          hint: "Write the client review or feedback here...",
          isRequired: true,
          minLines: 4,
          maxLines: 6,
        ),
      ],
    );
  }

  // ================= STEP 2: PHOTO & PUBLISH =================
  Widget _buildPhotoAndPublishStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Photo & Publish Settings"),
        const SizedBox(height: 14),

        // Client Photo Card
        Container(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  "Client Photo (Optional)",
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: _photoPathCtrl.text.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _photoPathCtrl.text,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF0F172A)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _photoPathCtrl.text,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _photoPathCtrl.clear();
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
                                child: const Icon(Icons.close,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            _photoPathCtrl.text = "assets/images/app_logo.png";
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: CustomPaint(
                          painter: _TestimonialDashedRectPainter(
                            color: isDark
                                ? const Color(0xFF475569)
                                : const Color(0xFFCBD5E1),
                            dash: 5,
                            gap: 4,
                            radius: 8,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 28,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Drag & drop or click to upload photo",
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
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Publish Card
        Container(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // Status Row
                    Row(
                      children: [
                        Icon(
                          Icons.vpn_key_outlined,
                          size: 16,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
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
                                text: _isActive ? "Active" : "Inactive",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isActive
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _isActive,
                          activeThumbColor: const Color(0xFF00A3FF),
                          onChanged: (val) {
                            setState(() => _isActive = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Rating Summary Row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Rating: $_rating / 5 Stars",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
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
      ],
    );
  }

  // ================= FORM HELPER WIDGETS =================
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF10B981),
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
    Widget? prefixIcon,
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
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                "*",
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 12.5,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              ),
              prefixIcon: prefixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _TestimonialDashedRectPainter extends CustomPainter {
  final Color color;
  final double gap;
  final double dash;
  final double radius;
  static const double strokeWidth = 1.2;

  _TestimonialDashedRectPainter({
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
