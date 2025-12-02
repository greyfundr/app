import 'dart:io';
import 'dart:convert'; // Import for jsonEncode and jsonDecode

class Wallet
{
  final int id;
  final double balance;
  final double incoming_balance;
  final double balance_owed;

  Wallet({required this.id, required this.balance, required this.incoming_balance, required this.balance_owed});

  Map<String, dynamic> toJson() => {
    "id": id,
    "balance": balance,
    "incoming_balance": incoming_balance,
    "balance_owed": balance_owed,
  };

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    balance: json["balance"],
    incoming_balance: json["incoming_balance"],
    balance_owed: json["balance_owed"],
  );

}
