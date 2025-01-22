import 'package:flutter/material.dart';

class Subcarousel extends StatelessWidget {
    final List lists;
  final double width;

  const Subcarousel({super.key, required this.lists,this.width=130});
 
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
                        image: NetworkImage(
                          lists[index]["image"],
                        ),
                        fit: BoxFit.cover)),
      ),
    );
            }));
  }
}
