import 'package:flutter/material.dart';

class FoodPixel extends StatelessWidget {

  final int index;
  const FoodPixel({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(4),
      ),
        child: Center(
          //child: Text("$index",style: TextStyle(color: Colors.white),),
        ),),
    );
  }
}
