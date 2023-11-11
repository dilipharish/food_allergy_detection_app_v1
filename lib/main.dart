import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/admin_screen.dart';

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

  String _scanBarcodeResult = '';
  bool isDiabetic = false; // Default value
  bool isCancerPatient = false; // Default value
  bool hasHighBloodPressure = false; // Default value
  bool shouldAvoidProduct = false; // Default value
  bool productindatabase = true;

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

  void scanbarcode() async {
    // ... (barcode scanning code)
    String barcodeScanres;
    try {
      barcodeScanres = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanres = "Failed to get platform version";
    }
    setState(() {
      _scanBarcodeResult = barcodeScanres;
    });

    // Barcode values and their respective sugar contents.
    Map<String, double> productInfo = {
      '8901030807206': 45.0, //horlicks
      '8901030831713': 65.0, //kisan jam
    };

    // Check if the scanned barcode is in the productInfo map.
    if (productInfo.containsKey(barcodeScanres)) {
      double sugarContent = productInfo[barcodeScanres]!;

      // Check if the sugar content is higher than a certain threshold (e.g., 50g).
      if (sugarContent > 50.0) {
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
        productindatabase = false;
      });
    }
  }

  String getRecommendationText() {
    if (productindatabase) {
      if (shouldAvoidProduct) {
        return "It is better to avoid this product.";
      } else {
        return "It is good to use this product.";
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              onPressed: scanbarcode,
              child: Text("Start Barcode Scan"),
            ),
            Text("Barcode Result: $_scanBarcodeResult"),
            ElevatedButton(
              onPressed: () {
                // Provide a recommendation based on user's diabetic status and sugar content.
                String recommendation = getRecommendationText();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Product Recommendation'),
                      content: Text(recommendation),
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
    );
  }
}
