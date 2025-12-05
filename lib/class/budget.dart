import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class Expense {
  String name;
  double cost;
  String? file;

  Expense({required this.name, required this.cost, this.file});

  // Add copyWith for deep copying
  Expense copyWith({
    String? name,
    double? cost,
    String? file,
  }) {
    return Expense(
      name: name ?? this.name,
      cost: cost ?? this.cost,
      file: file ?? this.file,
    );
  }



  // Convert object to a Map
  Map<String, dynamic> toJson() => {
    "name": name,
    "cost": cost,
    "file": file,
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    name: json["name"],
    cost: json["cost"],
    file: json["file"],
  );

  factory Expense.fromMap(Map<String, String> map) {
    return Expense(
      name: map['name']!,
      cost: double.parse(map['amount']!), // Convert string to double
      file: map['file']!,
    );
  }

  List<Map<String, String>> convertExpensesToMaps(List<Expense> expenses) {
    return expenses.map((expense) => {
      'name': expense.name, // Assuming 'name' is a property of your Expense class
      'cost': expense.cost.toString(), // Convert amount to string if needed
      // Add other properties as key-value pairs
    }).toList();
  }
}