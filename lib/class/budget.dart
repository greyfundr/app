import 'dart:convert';
import 'dart:io'; // Import for jsonEncode and jsonDecode

class Budget {
  final int description;
  final String expenditure;
  final String cost;
  final List<File> document;


  Budget({required this.description, required this.expenditure, required this.cost, required this.document});

  // Convert object to a Map
  Map<String, dynamic> toJson() => {
    "description": description,
    "expenditure": expenditure,
    "cost": cost,
    "document": document,
  };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    description: json["description"],
    expenditure: json["expenditure"],
    cost: json["cost"],
    document: json["document"],
  );
}