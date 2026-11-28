import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/blog_item_model.dart';
import '../../viewmodels/cms_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'edit_blog_screen.dart';

export '../../models/blog_item_model.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  bool get _isDarkMode => context.watch<ThemeViewModel>().isDarkMode;
  final int _entriesPerPage = 20;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();
  final List<BlogItem> _blogs = [];

  late final PagingController<int, BlogItem> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.keys == null || state.keys!.isEmpty) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.length < _entriesPerPage) return null;
      return (state.keys!.last) + 1;
    },
    fetchPage: (pageKey) async {
      final vm = context.read<CmsViewModel>();
      final items = await vm.fetchBlogsPage(
        pageKey: pageKey,
        pageSize: _entriesPerPage,
        searchQuery: _searchQuery,
      );
      if (mounted) {
        setState(() {
          if (pageKey == 1) _blogs.clear();
          _blogs.addAll(items);
        });
      }
      return items;
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openAddBlogScreen() async {
    final newBlog = BlogItem(
      id: "BLOG-${DateTime.now().millisecondsSinceEpoch}",
      title: "",
      author: "Admin",
      date: "01 Sep, 2026",
      isActive: true,
      description: "",
    );
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBlogScreen(
          blog: newBlog,
          isAdd: true,
        ),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _blogs.insert(0, newBlog);
      });
      _pagingController.refresh();
    }
  }

  void _showEditBlogDialog(BlogItem blog) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBlogScreen(blog: blog),
      ),
    );
    if (result == true && mounted) {
      setState(() {});
      _pagingController.refresh();
    }
  }

  void _deleteBlog(BlogItem blog) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
                      setState(() {
                        _blogs.removeWhere((b) => b.id == blog.id);
                      });
                      _pagingController.refresh();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Blog deleted successfully!"),
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

  @override
  Widget build(BuildContext context) {
    final displayedBlogs = _blogs;

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
            "Blogs Management",
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
          ),
        ),
        actions: [
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
                // 1. Search TextField (Full Width, 12px spacing above and below)
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
                    hintText: "Search...",
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

                // 2. Count & Compact "+ Add New" Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayedBlogs.isEmpty
                            ? "No Blogs"
                            : displayedBlogs.length == 1
                                ? "1 Blog"
                                : "${displayedBlogs.length} Blogs",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : AppColors.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: _openAddBlogScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.add,
                            size: 16, color: Colors.white),
                        label: Text(
                          "Add New",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Blogs List
          Expanded(
            child: PagingListener<int, BlogItem>(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      sliver: PagedSliverList<int, BlogItem>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate: PagedChildBuilderDelegate<BlogItem>(
                          itemBuilder: (ctx, blog, index) =>
                              _buildBlogCard(blog, index),
                          noItemsFoundIndicatorBuilder: (ctx) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 44,
                                    color: _isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No Blogs Found",
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
                          firstPageErrorIndicatorBuilder: (ctx) =>
                              _buildErrorIndicator(state.error),
                          newPageErrorIndicatorBuilder: (ctx) =>
                              _buildErrorIndicator(state.error),
                          newPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
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
        "Failed to load blogs";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 40, color: Color(0xFFDC2626)),
            const SizedBox(height: 10),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: _isDarkMode ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pagingController.refresh,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogCard(BlogItem blog, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
          // Row: Thumbnail + (Badges & Title)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail (Image or Placeholder)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 56,
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  alignment: Alignment.center,
                  child: blog.imagePath != null
                      ? (blog.imagePath!.startsWith('http')
                          ? Image.network(
                              blog.imagePath!,
                              width: 80,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => Icon(
                                Icons.image_outlined,
                                size: 24,
                                color: _isDarkMode
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade400,
                              ),
                            )
                          : Image.asset(
                              blog.imagePath!,
                              width: 80,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => Icon(
                                Icons.image_outlined,
                                size: 24,
                                color: _isDarkMode
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade400,
                              ),
                            ))
                      : Icon(
                          Icons.image_outlined,
                          size: 24,
                          color: _isDarkMode
                              ? Colors.grey.shade500
                              : Colors.grey.shade400,
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Badges & Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges: #S.N. + Active/Inactive
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "#${index + 1}",
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color:
                                  _isDarkMode ? Colors.white70 : AppColors.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: blog.isActive
                                ? AppColors.chipActiveBg
                                : AppColors.chipInactiveBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            blog.isActive ? "Active" : "Inactive",
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: blog.isActive
                                  ? AppColors.chipActiveText
                                  : AppColors.chipInactiveText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Blog Title
                    Text(
                      blog.title,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode
                            ? Colors.white
                            : const Color(0xFF0F172A),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 8),

          // Card Footer: Author · Date (Left) + Edit & Delete Icons (Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${blog.author} · ${blog.date}",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _isDarkMode
                      ? Colors.grey.shade400
                      : const Color(0xFF64748B),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _showEditBlogDialog(blog),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: _isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _deleteBlog(blog),
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
