class ProfessionModel {
  ProfessionModel({this.name, this.description});

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessionModel(
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
