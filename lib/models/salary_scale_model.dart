class SalaryScaleModel {
  SalaryScaleModel({this.minimumIncome, this.maximumIncome, this.incomeRange});

  factory SalaryScaleModel.fromJson(Map<String, dynamic> json) {
    return SalaryScaleModel(
      minimumIncome: json['minimum_income'],
      maximumIncome: json['maximum_income'],
      incomeRange: json['income_range'],
    );
  }

  final String? minimumIncome, maximumIncome, incomeRange;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'minimum_income': minimumIncome,
      'maximum_income': maximumIncome,
      'income_range': incomeRange,
    };

    return map..removeWhere((key, value) => value == '' || value == null);
  }
}
