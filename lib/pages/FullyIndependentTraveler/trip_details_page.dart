import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/independentTravelerPage.dart';

class TripDetailsPage extends StatelessWidget {
  const TripDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/tent_lake.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Navigates back to the previous screen
              },
            ),
          ),
          // Favorite Button
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
          // Card Content
          DraggableScrollableSheet(
            initialChildSize: 0.7, // Adjusted for a higher starting position
            minChildSize: 0.7, // Adjusted for a higher minimum size
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(bottom: 16),
                      ),
                    ),
                    Text(
                      "Nusa Pedina",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Bali, Indonesia",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoChip(icon: Icons.star, label: "4.8/5.0"),
                        _InfoChip(icon: Icons.location_on, label: "3000 km"),
                        _InfoChip(icon: Icons.access_time, label: "108 avail."),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Text(
                          "Nestled in the azure waters of the Indian Ocean, Nusa Penida is a pristine gem just a short boat ride from Bali, Indonesia, offering an unforgettable escape into paradise. This stunning island is renowned for its dramatic coastal cliffs, crystal-clear waters, and vibrant marine life, making it a haven for nature lovers and adventure seekers alike.\n\nExplore iconic spots like Kelingking Beach, often dubbed \"T-Rex Bay\" for its unique rock formation, where turquoise waves crash against white sandy shores. Dive into the underwater wonderland at Crystal Bay or Manta Point to swim alongside majestic manta rays and vibrant coral reefs. Take a hike to the breathtaking Angel's Billabong and Broken Beach, where natural rock formations create picture-perfect lagoons. For those seeking serenity, the island's lush hills and traditional villages offer a glimpse into the timeless Balinese culture."
                              "Nestled in the azure waters of the Indian Ocean, Nusa Penida is a pristine gem just a short boat ride from Bali, Indonesia, offering an unforgettable escape into paradise. This stunning island is renowned for its dramatic coastal cliffs, crystal-clear waters, and vibrant marine life, making it a haven for nature lovers and adventure seekers alike.\n\nExplore iconic spots like Kelingking Beach, often dubbed \"T-Rex Bay\" for its unique rock formation, where turquoise waves crash against white sandy shores. Dive into the underwater wonderland at Crystal Bay or Manta Point to swim alongside majestic manta rays and vibrant coral reefs. Take a hike to the breathtaking Angel's Billabong and Broken Beach, where natural rock formations create picture-perfect lagoons. For those seeking serenity, the island's lush hills and traditional villages offer a glimpse into the timeless Balinese culture.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 80,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Independenttravelerpage()));},
                        child: Text(
                          "Book A Trip",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _InfoChip({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: Colors.red, size: 20),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
