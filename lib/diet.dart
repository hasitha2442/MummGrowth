import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dietchart extends StatefulWidget {
  const Dietchart({super.key});

  @override
  State<Dietchart> createState() => _DietchartState();
}

class _DietchartState extends State<Dietchart> {
  Map<String, dynamic> recommendation = {};
  @override
  void initState() {
    super.initState();
    getRecommendation();
  }

  Future<void> getRecommendation() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000'),
    );

    if (response.statusCode == 200) {
      setState(() {
        recommendation = jsonDecode(response.body);
      });
    } else {
      print('Failed to get recommendation');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Recommendation App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text('Recommendation:'),
            DataTable(
              columns: [
                DataColumn(label: Text('Meal Type')),
                DataColumn(label: Text('Dish')),
              ],
              rows: [
                buildDataRow('Dryfruits', recommendation['Dryfruits']),
                buildDataRow('Seeds', recommendation['Seeds']),
                buildDataRow('Egg', recommendation['Egg']),
                buildDataRow('Breakfast', recommendation['Breakfast']),
                buildDataRow('Morning Snacks', recommendation['Morning Snacks']),
                buildDataRow('Lunch', recommendation['Lunch']),
                buildDataRow('Curd', recommendation['Curd']),
                buildDataRow('Evening Snacks', recommendation['Evening Snacks']),
                buildDataRow('Dinner', recommendation['Dinner']),
                buildDataRow('Milk', recommendation['Milk']),
              ],
            ),

            // Add more Text widgets for other recommendation details
          ],
        ),
      ),
    );
  }
  DataRow buildDataRow(String mealType, String dish) {
    return DataRow(
      cells: [
        DataCell(Text(mealType)),
        DataCell(Text(dish)),
      ],
    );
  }
}




