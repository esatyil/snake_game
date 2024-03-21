import 'package:flutter/material.dart';

class BlankPixel extends StatelessWidget {

  final int index;
  const BlankPixel({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        //child: Text("$index",style: TextStyle(color: Colors.white),),
      ),),
    );
  }
}
