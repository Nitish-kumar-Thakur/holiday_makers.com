import 'package:flutter/material.dart';

class Subcarousel2 extends StatelessWidget {
    final List lists;
  final double width;

  Subcarousel2({super.key, required this.lists,this.width=130});
  late PageController controller;
  @override
  void initState() {
    controller = PageController(
      initialPage: 0,
      viewportFraction: 0.40,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 200,
      child: ListView.builder( itemCount: lists.length,
             scrollDirection: Axis.horizontal,
             itemBuilder: (_, index) {
              return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container( height: 100,width: width,
        decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage(
                          lists[index],
                        ),
                        fit: BoxFit.cover)),
      ),
    );
            }));
  }
}
