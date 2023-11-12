import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/admin_screen.dart';
import 'package:food_allergy_detection_app_v1/constants.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Food Allergy Detection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String adminPassword =
      "admin123"; // Change this to your desired admin password
  String enteredPassword = "";
  String _productName = '';
  String recommendationText = ""; // Define recommendationText
  String _scanBarcodeResult = '';
  bool isDiabetic = false; // Default value
  bool isCancerPatient = false; // Default value
  bool hasHighBloodPressure = false; // Default value
  bool shouldAvoidProduct = false; // Default value
  bool productIndatabase = true;

  void _showDiabetesQuestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you susceptible to diabetes?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Yes'),
                leading: Radio(
                  value: true,
                  groupValue: isDiabetic,
                  onChanged: (value) {
                    setState(() {
                      isDiabetic = value!;
                    });
                    Navigator.of(context).pop();
                    _handleDiabeticStatus(value!);
                  },
                ),
              ),
              ListTile(
                title: Text('No'),
                leading: Radio(
                  value: false,
                  groupValue: isDiabetic,
                  onChanged: (value) {
                    setState(() {
                      isDiabetic = value!;
                    });
                    Navigator.of(context).pop();
                    _handleDiabeticStatus(value!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancerQuestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you have cancer?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Yes'),
                leading: Radio(
                  value: true,
                  groupValue: isCancerPatient,
                  onChanged: (value) {
                    setState(() {
                      isCancerPatient = value!;
                    });
                    Navigator.of(context).pop();
                    _handleCancerStatus(value!);
                  },
                ),
              ),
              ListTile(
                title: Text('No'),
                leading: Radio(
                  value: false,
                  groupValue: isCancerPatient,
                  onChanged: (value) {
                    setState(() {
                      isCancerPatient = value!;
                    });
                    Navigator.of(context).pop();
                    _handleCancerStatus(value!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBloodPressureQuestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you have high blood pressure?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Yes'),
                leading: Radio(
                  value: true,
                  groupValue: hasHighBloodPressure,
                  onChanged: (value) {
                    setState(() {
                      hasHighBloodPressure = value!;
                    });
                    Navigator.of(context).pop();
                    _handleBloodPressureStatus(value!);
                  },
                ),
              ),
              ListTile(
                title: Text('No'),
                leading: Radio(
                  value: false,
                  groupValue: hasHighBloodPressure,
                  onChanged: (value) {
                    setState(() {
                      hasHighBloodPressure = value!;
                    });
                    Navigator.of(context).pop();
                    _handleBloodPressureStatus(value!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleDiabeticStatus(bool isDiabetic) {
    // Perform actions based on the user's diabetic status.
    if (isDiabetic) {
      // If the user is diabetic, you can display a message or take other actions.
      // For example, show a message to be cautious about high-sugar products.
      setState(() {
        shouldAvoidProduct = true;
      });
    } else {
      // If the user is not diabetic, you can reset any previous warnings or actions.
      setState(() {
        shouldAvoidProduct = false;
      });
    }
  }

  void _handleCancerStatus(bool isCancerPatient) {
    setState(() {
      this.isCancerPatient = isCancerPatient;
    });
  }

  void _handleBloodPressureStatus(bool hasHighBloodPressure) {
    setState(() {
      this.hasHighBloodPressure = hasHighBloodPressure;
    });
  }

  bool productInDatabase = true;

  void scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }

    Map<String, dynamic>? productDetails =
        await fetchProductDetails(barcodeScanRes);

    if (productDetails != null) {
      double sugarContent =
          double.tryParse(productDetails['sugar_content'] ?? '0.0') ?? 0.0;
      String preservativesContent = productDetails['preservatives_content'];
      String oilsContent = productDetails['oils_content'];
      String fatsContent = productDetails['fats_content'];
      bool palmOil = productDetails['palm_oil'] == 1;

      setState(() {
        _productName = productDetails['product_name'];
        _scanBarcodeResult = barcodeScanRes;
        productInDatabase = true;
      });

      // Use the details as needed
      print("Product Name: $_productName");
      print("Sugar Content: $sugarContent");
      print("Preservatives Content: $preservativesContent");
      print("Oils Content: $oilsContent");
      print("Fats Content: $fatsContent");
      print("Palm Oil: $palmOil");

      // Check for diabetic condition
      if (isDiabetic) {
        if (sugarContent > 30.0) {
          setState(() {
            shouldAvoidProduct = true;
          });
        }
      } else if (isCancerPatient) {
        // Check for cancer patient condition
        if (preservativesContent != '0') {
          setState(() {
            shouldAvoidProduct = true;
          });
        }
      } else if (hasHighBloodPressure) {
        // Check for high blood pressure condition
        if (double.parse(oilsContent) > 10.0 ||
            double.parse(fatsContent) > 20.0) {
          setState(() {
            shouldAvoidProduct = true;
          });
        }
      } else if (palmOil) {
        // Check for palm oil
        setState(() {
          shouldAvoidProduct = true;
        });
      } else {
        setState(() {
          shouldAvoidProduct = false;
        });
      }
    } else {
      setState(() {
        productInDatabase = false;
        _productName = '';
        shouldAvoidProduct = false;
      });
      _showProductNotAvailableDialog(barcodeScanRes);
    }
  }

  Future<Map<String, dynamic>?> fetchProductDetails(String barcode) async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      var results1 = await conn
          .query('SELECT * FROM product WHERE product_barcode = ?', [barcode]);
      if (results1.isNotEmpty) {
        return results1.first.fields;
      }

      var results = await conn
          .query('SELECT * FROM added WHERE add_barcode = ?', [barcode]);
      if (results.isNotEmpty) {
        await conn.query(
            'UPDATE added SET demand = demand + 1 WHERE add_barcode = ?',
            [barcode]);
        return results.first.fields;
      }
    } catch (e) {
      print('Error fetching product details: $e');
    } finally {
      await conn.close();
    }

    return null;
  }

  void _showProductNotAvailableDialog(String barcode) async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      var resultsProduct = await conn
          .query('SELECT * FROM product WHERE product_barcode = ?', [barcode]);

      if (resultsProduct.isEmpty) {
        setState(() {
          productInDatabase = false;
          _productName = ''; // Reset productName when product is not found
          shouldAvoidProduct = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Product Not Found'),
              content: Column(
                children: [
                  Text('The scanned product is not available in the database.'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _reportProductToAdmin(barcode);
                    },
                    child: Text('Report to Admin'),
                  ),
                ],
              ),
              actions: <Widget>[
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
      }
    } catch (e) {
      print('Error checking product availability: $e');
    } finally {
      await conn.close();
    }
  }

  void _reportProductToAdmin(String barcode) async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      await conn.query(
          'INSERT INTO added (add_barcode, demand) VALUES (?, 1)', [barcode]);
    } catch (e) {
      print('Error reporting product to admin: $e');
    } finally {
      await conn.close();
    }
  }

  String getRecommendationText() {
    if (productInDatabase) {
      if (shouldAvoidProduct) {
        return "It is better to avoid $_productName.";
      } else {
        return "It is good to use $_productName.";
      }
    } else {
      return "product not found in database";
      // return "It is good to use this product.";
    }
  }

  void _showAdminPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Admin Password'),
          content: TextField(
            onChanged: (value) {
              enteredPassword = value;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (enteredPassword == adminPassword) {
                  Navigator.of(context).pop(); // Close the password dialog
                  _navigateToAdminScreen();
                } else {
                  // Show an error message or handle incorrect password
                  // You can add a state variable to display an error message in the dialog.
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAdminScreen() {
    // Navigate to the admin screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Admin?'),
              onTap: () {
                _showAdminPasswordDialog();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Welocme To Food Allergy Detection Flutter App"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showDiabetesQuestionDialog,
                child: Text("Are you susceptible to diabetes?"),
              ),
              Text("Diabetic: ${isDiabetic ? 'Yes' : 'No'}"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showCancerQuestionDialog,
                child: Text("Do you have cancer?"),
              ),
              Text("Has Cancer: ${isCancerPatient ? 'Yes' : 'No'}"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showBloodPressureQuestionDialog,
                child: Text("Do you have high blood pressure?"),
              ),
              Text(
                  "Has high blood pressure: ${hasHighBloodPressure ? 'Yes' : 'No'}"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: scanBarcode,
                child: Text("Start Barcode Scan"),
              ),
              Text("Barcode Result: $_scanBarcodeResult\n"),
              Text("Product: $_productName"),
              ElevatedButton(
                onPressed: () {
                  // Provide a recommendation based on the user's diabetic status and sugar content.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Product Recommendation'),
                        content: Text(getRecommendationText()),
                        actions: <Widget>[
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
                },
                child: Text("Get Recommendation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
