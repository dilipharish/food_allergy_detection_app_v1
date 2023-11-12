import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/class_product.dart';
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
        if (results is Results) {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productList.isEmpty
            ? Text('No products available.')
            : PaginatedDataTable(
                columns: [
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Barcode')),
                  DataColumn(label: Text('Sugar Content')),
                  DataColumn(label: Text('Preservatives Content')),
                  DataColumn(label: Text('Oils Content')),
                  DataColumn(label: Text('Fats Content')),
                  DataColumn(label: Text('Palm Oil')),
                  DataColumn(label: Text('Actions')),
                ],
                rowsPerPage: 5,
                source: MyDataTableSource(productList, _deleteProduct),
              ),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> productList;
  final Function(int) onDelete;

  MyDataTableSource(this.productList, this.onDelete);

  @override
  DataRow getRow(int index) {
    final product = productList[index];

    return DataRow(
      cells: [
        DataCell(Text(product['product_name'])),
        DataCell(Text(product['product_barcode'])),
        DataCell(Text(product['sugar_content'].toString())),
        DataCell(Text(product['preservatives_content'].toString())),
        DataCell(Text(product['oils_content'].toString())),
        DataCell(Text(product['fats_content'].toString())),
        DataCell(Text(product['palm_oil'].toString())),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton(
              //   icon: Icon(Icons.edit),
              //   onPressed: () {
              //     _editProduct(product['product_id']);
              //   },
              // ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  onDelete(product['product_id']);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => productList.length;

  @override
  int get selectedRowCount => 0;
}
