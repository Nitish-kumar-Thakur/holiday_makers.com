import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class TestimonialsPage extends StatefulWidget {
  const TestimonialsPage({super.key});

  @override
  _TestimonialsPageState createState() => _TestimonialsPageState();
}

class _TestimonialsPageState extends State<TestimonialsPage> {
  late Future<List<dynamic>> _testimonialsFuture;

  @override
  void initState() {
    super.initState();
    _testimonialsFuture = _fetchTestimonials();
  }

  Future<List<dynamic>> _fetchTestimonials() async {
    try {
      final response = await APIHandler.HomePageData();
      if (response['data'] != null && response['data']['testimonials'] != null) {
        return response['data']['testimonials'];
      }
      throw Exception("No testimonials found");
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Testimonials'),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: _testimonialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load testimonials: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // Show "No Testimonials available currently" if the list is empty
              return Center(
                child: Text(
                  'No Testimonials available currently.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                ),
              );
            } else {
              // Show the testimonials list
              final testimonials = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: testimonials.length,
                itemBuilder: (context, index) {
                  final testimonial = testimonials[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TestimonialCard(
                      name: testimonial['person_name'] ?? 'Anonymous',
                      rating:
                      int.tryParse(testimonial['star_rating'] ?? '0') ?? 0,
                      testimonial: testimonial['description'] ?? '',
                      image: testimonial['person_img'] ??
                          'assets/images/default_user.png',
                      createdAt: testimonial['created_at'] ?? '',
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: Text(
                'No Testimonials available currently.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
            );
          }
        },
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String name;
  final int rating;
  final String testimonial;
  final String image;
  final String createdAt;

  const TestimonialCard({
    super.key,
    required this.name,
    required this.rating,
    required this.testimonial,
    required this.image,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24.0,
                  backgroundImage: image.startsWith('http')
                      ? NetworkImage(image)
                      : AssetImage('img/placeholder.png') as ImageProvider,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          rating,
                              (index) => Icon(
                            Icons.star,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        testimonial,
                        style:
                        TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatDate(createdAt),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format the `created_at` date string
  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (e) {
      return "Invalid date";
    }
  }
}
