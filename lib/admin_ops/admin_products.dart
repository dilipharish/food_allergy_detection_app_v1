import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/view_products.dart';
import 'package:food_allergy_detection_app_v1/constants.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mysql1/mysql1.dart';

class AdminProductScreen extends StatefulWidget {
  @override
  _AdminProductScreenState createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController preservativesController = TextEditingController();
  final TextEditingController oilsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  bool palmOil = false;
  String scannedBarcode = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _addProductToDatabase(BuildContext context) async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      await conn.query(
        'INSERT INTO product (product_barcode, product_name, sugar_content, preservatives_content, oils_content, fats_content, palm_oil) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          barcodeController.text,
          nameController.text,
          sugarController.text,
          preservativesController.text,
          oilsController.text,
          fatsController.text,
          palmOil,
        ],
      );

      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Success'),
      //       content: Text('Product added successfully'),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error adding product: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      await conn.close();
    }
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    ).then((value) {
      setState(() {
        scannedBarcode = value;
        barcodeController.text = scannedBarcode;
      });
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _startBarcodeScanning();
                    },
                    child: Text('Scan Barcode'),
                  ),
                  SizedBox(height: 16),
                  Text('Scanned Barcode: ${barcodeController.text}'),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: sugarController,
                    decoration: InputDecoration(labelText: 'Sugar Content'),
                  ),
                  TextField(
                    controller: preservativesController,
                    decoration:
                        InputDecoration(labelText: 'Preservatives Content'),
                  ),
                  TextField(
                    controller: oilsController,
                    decoration: InputDecoration(labelText: 'Oils Content'),
                  ),
                  TextField(
                    controller: fatsController,
                    decoration: InputDecoration(labelText: 'Fats Content'),
                  ),
                  Row(
                    children: [
                      Text('Palm Oil:'),
                      Checkbox(
                        value: palmOil,
                        onChanged: (value) {
                          setState(() {
                            palmOil = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addProductToDatabase(context); // Perform database insertion
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Add Product'),
            ),
          ],
        );
      },
    );
  }

  void _startBarcodeScanning() async {
    String barcodeScanResult;
    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanResult = "Failed to get platform version";
    }

    setState(() {
      scannedBarcode = barcodeScanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddProductDialog(context);
              },
              child: Text('Add Product'),
            ),
            SizedBox(
              height: 20,
            ),
            ViewProductScreen(),
          ],
        ),
      ),
    );
  }
}
