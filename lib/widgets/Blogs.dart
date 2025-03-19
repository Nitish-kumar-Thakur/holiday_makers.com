import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/blog_details_page.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:flutter/material.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  late Future<List<dynamic>> _blogsFuture;
  List<dynamic> _allBlogs = [];
  List<dynamic> _filteredBlogs = [];

  @override
  void initState() {
    super.initState();
    _blogsFuture = _fetchBlogs();
  }

  Future<List<dynamic>> _fetchBlogs() async {
    try {
      final response = await APIHandler.HomePageData();
      if (response['data'] != null && response['data']['blogs'] != null) {
        _allBlogs = response['data']['blogs'];
        _filteredBlogs = List.from(_allBlogs); // Populate _filteredBlogs initially
        print('Blogs fetched: $_allBlogs'); // Debugging
        return _allBlogs;
      }
      throw Exception("No blogs found");
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  void _filterBlogs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBlogs = List.from(_allBlogs); // Reset to all blogs
      });
    } else {
      setState(() {
        _filteredBlogs = _allBlogs.where((blog) {
          final title = blog['blog_title']?.toLowerCase() ?? '';
          final description = blog['description']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase()) ||
              description.contains(query.toLowerCase());
        }).toList();
      });
    }
    print('Filtered blogs: $_filteredBlogs'); // Debugging
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Blogs',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<dynamic>>(
        future: _blogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load blogs: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No blogs available currently.'),
            );
          } else {
            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => _filterBlogs(value), // Trigger search
                    decoration: InputDecoration(
                      hintText: 'Search blogs...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Blog List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: _filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = _filteredBlogs[index];
                      return BlogCard(
                        image: blog['home_image'] ??
                            'https://via.placeholder.com/300x150', // Fallback if image is null
                        title: blog['blog_title'] ?? 'No title available',
                        description: _stripHtmlTags(blog['description'] ?? ''),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String _stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regex, '');
  }
}

class BlogCard extends StatelessWidget {
  final String? image; // Image can now be nullable
  final String title;
  final String description;

  const BlogCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blog image or grey fallback
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: image != null && image!.isNotEmpty
                ? Image.network(
              image!, // Dynamic image from API
              height: 150.0,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(
              height: 150.0,
              width: double.infinity,
              color: Colors.grey[300], // Grey background as fallback
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey[600],
                size: 40.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blog title
                Text(
                  title, // Dynamic title from API
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                // Blog description
                Text(
                  description, // Stripped description from API
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 12.0),
                // Read more button
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to BlogDetailsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailsPage(
                            image: image ?? '',
                            title: title,
                            description: description,
                          ),
                        ),
                      );
                    },
                    child: responciveButton(text: 'Read More'),
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
