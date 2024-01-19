import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListDetails extends StatefulWidget {
  const ListDetails({Key? key}) : super(key: key);

  @override
  State<ListDetails> createState() => _ListDetailsState();
}

class _ListDetailsState extends State<ListDetails> {
  List<String> hospitals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.82.42:3000'));
      print(response.body);
      if (response.statusCode == 200) {
        List<String> data = response.body.split('\n');

        setState(() {
          hospitals = data;
        });
      } else {
        setState(() {
          hospitals = ['Error fetching data'];
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        hospitals = ['Error fetching data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Hospitals'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nearest Hospitals:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Expanded(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Hospital')),
                  ],
                  rows: hospitals.isNotEmpty
                      ? hospitals
                          .map(
                            (hospital) => DataRow(
                              cells: [
                                DataCell(Text(hospital)),
                              ],
                            ),
                          )
                          .toList()
                      : [
                          DataRow(
                            cells: [
                              DataCell(Text('No data available')),
                            ],
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
