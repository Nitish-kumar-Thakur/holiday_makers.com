import 'package:flutter/material.dart';

class Hotels extends StatefulWidget {
  final int index;
  const Hotels({super.key,
  this.index=1});

  @override
  State<Hotels> createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            padding: EdgeInsets.all(16),
            height: isExpanded ? 250 : 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Card ${widget.index + 1}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "This is a brief description of Card ${widget.index + 1}.",
                  maxLines: isExpanded ? null : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isExpanded) ...[
                  SizedBox(height: 10),
                  Text(
                    "This additional text is shown when the card is expanded. You can add more details or dynamic content here.",
                  ),
                ],
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(isExpanded ? "Read Less" : "Read More"),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
