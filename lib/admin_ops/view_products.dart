import 'package:flutter/material.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/class_product.dart';
import 'package:mysql1/mysql1.dart';
import 'package:food_allergy_detection_app_v1/constants.dart';

class ViewProductScreen extends StatefulWidget {
  @override
  _ViewProductScreenState createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      var results = await conn.query('SELECT * FROM product');
      setState(() {
        // Check the type of the results
        if (results is Results) {
          // Convert to List<Map<String, dynamic>>
          productList = results
              .toList()
              .map((ResultRow row) =>
                  Product.fromMap(row.fields).toMap()) // Convert Product to Map
              .toList();
        } else {
          print('Unexpected type for database results');
        }
      });
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> _editProduct(int productId) async {
    // Implement the edit logic
    // You can navigate to another screen for editing or show a dialog for editing
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(productId)));
  }

  Future<void> _deleteProduct(int productId) async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      await conn.query('DELETE FROM product WHERE product_id = ?', [productId]);
      _fetchProducts();
    } catch (e) {
      print('Error deleting product: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child // Show a message if the list is empty
            : ListView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          itemBuilder: (context, index) {
            final product = productList[index];
            return Card(
              child: ListTile(
                title: Text(product['product_name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Barcode: ${product['product_barcode']}'),
                    Text('Sugar Content: ${product['sugar_content']}'),
                    Text(
                        'Preservatives Content: ${product['preservatives_content']}'),
                    Text('Oils Content: ${product['oils_content']}'),
                    Text('Fats Content: ${product['fats_content']}'),
                    Text('Palm Oil: ${product['palm_oil']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editProduct(product['product_id']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteProduct(product['product_id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
