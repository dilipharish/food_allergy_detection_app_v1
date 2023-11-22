import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height * 2,
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Text("The Threshold for Salt Content is 0.4g\n"),
                SizedBox(
                  height: 10,
                ),
                Text("The Presence of Palm oil is not really Healthy \n"),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "The Presence of Preservatives is Harmful for Cancerous person\n ")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
