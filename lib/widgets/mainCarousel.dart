import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Maincarousel extends StatefulWidget {
  final List<Map<String, dynamic>> banner_list;

  const Maincarousel({super.key, required this.banner_list});

  @override
  _MaincarouselState createState() => _MaincarouselState();
}

class _MaincarouselState extends State<Maincarousel> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.banner_list.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.banner_list[index]['mobile_img'],
                    // Optionally add a placeholder or handle error.
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            aspectRatio: 16 / 9,
            onPageChanged: (index, carouselPageChangedReason) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
              activeIndex: currentPage,
              count: widget.banner_list.length,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.red,
                dotColor: Colors.blue.shade200.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
