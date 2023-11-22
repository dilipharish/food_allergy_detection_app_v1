import 'package:flutter/material.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/view_added.dart';

class AdminTobeaddedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 2, // Set your desired height
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        child: SingleChildScrollView(
          child: Column(
            children: [ViewAddedScreen()],
          ),
        ),
      ),
    );
  }
}
