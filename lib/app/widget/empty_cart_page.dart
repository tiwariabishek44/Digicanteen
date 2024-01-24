import 'package:flutter/material.dart';

class EmptyCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/empty.png', // Replace with your image asset path
              width: 200, // Adjust image width as needed
              height: 200, // Adjust image height as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 8),
            child: Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
