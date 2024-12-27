import 'package:flutter/material.dart';

class Listicon extends StatelessWidget {
  const Listicon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 50,width: 50,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('img/group.png'))),
    );
  }
}