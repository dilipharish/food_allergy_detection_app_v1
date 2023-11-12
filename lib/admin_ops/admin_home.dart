import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text("Welcome To Admin Screen \n"),
            SizedBox(
              height: 10,
            ),
            Text("The Threshold for Sugar Content is 30g\n"),
            SizedBox(
              height: 10,
            ),
            Text("The Threshold for Oil Content is 10g\n"),
            SizedBox(
              height: 10,
            ),
            Text("The Threshold for Fats Content is 20g\n"),
            SizedBox(
              height: 10,
            ),
            Text("The Presence of Palm oil is not really Healthy \n"),
            SizedBox(
              height: 10,
            ),
            Text("The Harmful Preservatives are 202, MSG, KCl")
          ],
        ),
      ),
    );
  }
}
