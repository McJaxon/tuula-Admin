class TransactionTypeModel {
  TransactionTypeModel({this.name, this.description});

  factory TransactionTypeModel.fromJson(Map<String, dynamic> json) {
    return TransactionTypeModel(
      name: json['name'],
      description: json['description'],
    );
  }

  final String? name, description;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'description': description,
    };

    return map..removeWhere((key, value) => value == '' || value == null);
  }
}
