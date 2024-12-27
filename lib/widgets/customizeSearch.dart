import 'package:flutter/material.dart';

class Customizesearch extends StatelessWidget {
  Customizesearch({super.key});
 final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container( decoration: BoxDecoration(color: Colors.lightBlue.shade50,
    borderRadius: BorderRadius.circular(10),),
      width: 340,
      height: 54,
      child: Row( 
        children: [
          Expanded(child: 
          TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.black54, fontSize: 20),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.black54,size: 30,),
                  ),
      
    ))
        ],
      )   
      );
  }
}