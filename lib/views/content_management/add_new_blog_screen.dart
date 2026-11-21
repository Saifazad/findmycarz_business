import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blogs_screen.dart';

class AddNewBlogScreen extends StatefulWidget {
  final Function(BlogItem)? onBlogAdded;

  const AddNewBlogScreen({super.key, this.onBlogAdded});

  @override
  State<AddNewBlogScreen> createState() => _AddNewBlogScreenState();
}

class _AddNewBlogScreenState extends State<AddNewBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _status = "Active";
  String _visibility = "Public";
  String _publishTime = "Immediately";
  int _mediaCount = 0;
  String? _selectedCoverImage;

  @override
  void dispose() {
    _titleController.dispose();
    _writerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onPublish() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a blog title"),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    final newBlog = BlogItem(
      id: "BLOG-${DateTime.now().millisecondsSinceEpoch}",
      title: _titleController.text.trim(),
      author: _writerController.text.trim().isEmpty
          ? "Admin"
          : _writerController.text.trim(),
      date: "Today",
      isActive: _status.toLowerCase() == "active",
      imagePath: _selectedCoverImage,
    );

    widget.onBlogAdded?.call(newBlog);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Blog published successfully!"),
        backgroundColor: Color(0xFF0F766E),
      ),
    );
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Blog saved as draft"),
        backgroundColor: Color(0xFF475569),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: "Add New Blog" on Left, "Back to List" on Right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add New Blog",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      "Back to List",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Responsive layout: 2 Columns on wide screen, Stack on small screen
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (Blog Details + Media Gallery)
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBlogDetailsCard(),
                              const SizedBox(height: 24),
                              _buildMediaGalleryCard(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right Column (Publish + Cover Image)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPublishCard(),
                              const SizedBox(height: 24),
                              _buildCoverImageCard(),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBlogDetailsCard(),
                        const SizedBox(height: 20),
                        _buildPublishCard(),
                        const SizedBox(height: 20),
                        _buildCoverImageCard(),
                        const SizedBox(height: 20),
                        _buildMediaGalleryCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card 1: Blog Details
  Widget _buildBlogDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Blog Details",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),

          // Title *
          _buildFieldLabel("Title"),
          const SizedBox(height: 6),
          _buildPrefixedTextField(
            controller: _titleController,
            icon: Icons.edit_outlined,
          ),
          const SizedBox(height: 16),

          // Writer *
          _buildFieldLabel("Writer"),
          const SizedBox(height: 6),
          _buildPrefixedTextField(
            controller: _writerController,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // Description *
          _buildFieldLabel("Description"),
          const SizedBox(height: 6),
          _buildRichTextEditor(),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF334155),
        ),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrefixedTextField({
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
              color: Color(0xFFF8FAFC),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(fontSize: 13),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WYSIWYG Rich text editor mockup
  Widget _buildRichTextEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1 of tools
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildToolbarButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.code,
                              size: 13, color: Color(0xFF475569)),
                          const SizedBox(width: 3),
                          Text("Source",
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: const Color(0xFF475569))),
                        ],
                      ),
                    ),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.save_outlined),
                    _buildIconTool(Icons.description_outlined),
                    _buildIconTool(Icons.print_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.content_cut_outlined),
                    _buildIconTool(Icons.content_copy_outlined),
                    _buildIconTool(Icons.content_paste_outlined),
                    _buildIconTool(Icons.paste_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.undo_outlined),
                    _buildIconTool(Icons.redo_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.search_outlined),
                    _buildIconTool(Icons.find_replace_outlined),
                    _buildIconTool(Icons.select_all_outlined),
                    _buildIconTool(Icons.format_clear_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.format_color_text_outlined),
                    _buildIconTool(Icons.format_color_fill_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.check_box_outlined),
                    _buildIconTool(Icons.radio_button_checked_outlined),
                    _buildIconTool(Icons.text_fields_outlined),
                  ],
                ),
                const SizedBox(height: 4),
                // Row 2 of tools
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildIconTool(Icons.format_bold_outlined),
                    _buildIconTool(Icons.format_italic_outlined),
                    _buildIconTool(Icons.format_underlined_outlined),
                    _buildIconTool(Icons.strikethrough_s_outlined),
                    _buildIconTool(Icons.subscript_outlined),
                    _buildIconTool(Icons.superscript_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.format_list_numbered_outlined),
                    _buildIconTool(Icons.format_list_bulleted_outlined),
                    _buildIconTool(Icons.format_indent_decrease_outlined),
                    _buildIconTool(Icons.format_indent_increase_outlined),
                    _buildIconTool(Icons.format_quote_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.format_align_left_outlined),
                    _buildIconTool(Icons.format_align_center_outlined),
                    _buildIconTool(Icons.format_align_right_outlined),
                    _buildIconTool(Icons.format_align_justify_outlined),
                    _buildToolbarDivider(),
                    _buildIconTool(Icons.link_outlined),
                    _buildIconTool(Icons.link_off_outlined),
                    _buildIconTool(Icons.anchor_outlined),
                    _buildIconTool(Icons.image_outlined),
                    _buildIconTool(Icons.table_chart_outlined),
                    _buildIconTool(Icons.horizontal_rule_outlined),
                    _buildIconTool(Icons.sentiment_satisfied_outlined),
                  ],
                ),
                const SizedBox(height: 4),
                // Row 3: Dropdowns (Style, Format, Font, Size)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildToolbarDropdown("Style"),
                    _buildToolbarDropdown("Format"),
                    _buildToolbarDropdown("Font"),
                    _buildToolbarDropdown("Size"),
                  ],
                ),
              ],
            ),
          ),
          // Editor Input Area
          TextField(
            controller: _descriptionController,
            maxLines: 12,
            minLines: 8,
            style: GoogleFonts.poppins(fontSize: 13, height: 1.5),
            decoration: InputDecoration(
              hintText: "Enter blog content here...",
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: child,
    );
  }

  Widget _buildIconTool(IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Icon(icon, size: 15, color: const Color(0xFF475569)),
      ),
    );
  }

  Widget _buildToolbarDivider() {
    return Container(
      height: 16,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: const Color(0xFFCBD5E1),
    );
  }

  Widget _buildToolbarDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down, size: 14, color: Color(0xFF64748B)),
        ],
      ),
    );
  }

  // Card 2: Media Gallery
  Widget _buildMediaGalleryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Media Gallery icon + Title + "0" green pill
          Row(
            children: [
              const Icon(Icons.photo_library_outlined,
                  size: 18, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                "Media Gallery",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$_mediaCount",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dashed border upload area
          InkWell(
            onTap: () {
              setState(() {
                _mediaCount++;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Media uploaded to gallery"),
                  backgroundColor: Color(0xFF10B981),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: const Color(0xFFCBD5E1),
                strokeWidth: 1.2,
                gap: 4,
                dash: 5,
                radius: 8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 42,
                      color: Color(0xFF00C853),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Drag & Drop, Click to Upload, or Paste YouTube Link (Ctrl+V)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
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

  // Right Card 1: Publish
  Widget _buildPublishCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Publish",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),

          // Save Draft & Preview Buttons
          Row(
            children: [
              OutlinedButton(
                onPressed: _onSaveDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "Save Draft",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF94A3B8),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "Preview",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),

          // Metadata 1: Status: Active
          _buildPublishMetadataRow(
            icon: Icons.key_outlined,
            label: "Status: ",
            value: _status,
            onEdit: () {
              setState(() {
                _status = _status == "Active" ? "Inactive" : "Active";
              });
            },
          ),
          const SizedBox(height: 10),

          // Metadata 2: Visibility: Public
          _buildPublishMetadataRow(
            icon: Icons.visibility_outlined,
            label: "Visibility: ",
            value: _visibility,
            onEdit: () {
              setState(() {
                _visibility = _visibility == "Public" ? "Private" : "Public";
              });
            },
          ),
          const SizedBox(height: 10),

          // Metadata 3: Publish: Immediately
          _buildPublishMetadataRow(
            icon: Icons.calendar_month_outlined,
            label: "Publish: ",
            value: _publishTime,
            onEdit: () {
              setState(() {
                _publishTime =
                    _publishTime == "Immediately" ? "Scheduled" : "Immediately";
              });
            },
          ),
          const SizedBox(height: 18),

          // Bottom Action: Blue Publish Button (right-aligned as in screenshot)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _onPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0091FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: Text(
                "Publish",
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishMetadataRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onEdit,
          child: Text(
            "Edit",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF10B981),
            ),
          ),
        ),
      ],
    );
  }

  // Right Card 2: Cover Image
  Widget _buildCoverImageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cover Image",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              setState(() {
                _selectedCoverImage = "assets/images/car.webp";
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cover image selected"),
                  backgroundColor: Color(0xFF10B981),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: const Color(0xFFCBD5E1),
                strokeWidth: 1.2,
                gap: 4,
                dash: 5,
                radius: 8,
              ),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  _selectedCoverImage != null
                      ? "Cover Image Selected: car.webp"
                      : "Drag & drop or click to upload",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for clean dashed borders
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dash = 5.0,
    this.gap = 3.0,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
          size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + dash > metric.length)
            ? metric.length - distance
            : dash;
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap ||
        oldDelegate.radius != radius;
  }
}
