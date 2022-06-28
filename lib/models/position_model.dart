class PositionModel {
  PositionModel({this.position, this.description, required this.level});

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      position: json['position'],
      level: json['level'],
      description: json['description'],
    );
  }

  final String? position, description;
  final int level;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'position': position,
      'level': level,
      'description': description,
    };

    return map..removeWhere((key, value) => value == '' || value == null);
  }
}
