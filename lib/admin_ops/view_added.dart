import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:food_allergy_detection_app_v1/constants.dart';
import 'class_added.dart'; // Import your Added class

class ViewAddedScreen extends StatefulWidget {
  @override
  _ViewAddedScreenState createState() => _ViewAddedScreenState();
}

class _ViewAddedScreenState extends State<ViewAddedScreen> {
  List<Map<String, dynamic>> addedList = [];

  @override
  void initState() {
    super.initState();
    _fetchAdded();
  }

  Future<void> _fetchAdded() async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      var results = await conn.query('SELECT * FROM added');
      setState(() {
        if (results is Results) {
          addedList = results
              .toList()
              .map((ResultRow row) => Added.fromMap(row.fields).toMap())
              .toList();
        } else {
          print('Unexpected type for database results');
        }
      });
    } catch (e) {
      print('Error fetching added: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> _deleteAdded(int addedId) async {
    final MySqlConnection conn = await MySqlConnection.connect(settings);

    try {
      await conn.query('DELETE FROM added WHERE add_id = ?', [addedId]);
      _fetchAdded();
    } catch (e) {
      print('Error deleting added: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addedList.length,
            itemBuilder: (context, index) {
              final added = addedList[index];
              return Card(
                child: ListTile(
                  title: Text('Barcode: ${added['add_barcode']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Demand: ${added['demand']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Your edit button if needed
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAdded(added['add_id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
