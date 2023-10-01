class Transaksi {
  int? id;
  String type; 
  double amount;
  String date;
  String description;

  Transaksi({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date,
      'description': description,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      date: map['date'],
      description: map['description'],
    );
  }
}
