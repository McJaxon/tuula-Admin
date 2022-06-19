class LoanCategoryModel {
LoanCategoryModel(
      {this.loanType,
      this.interestType,
      this.abbreviation,
      this.description,
      this.maxAmount,
      this.minAmount,
      this.interestRate,
      this.termPeriod,
      this.term});

  factory LoanCategoryModel.fromJson(Map<String, dynamic> json) {
    return LoanCategoryModel(
      loanType: json['loan_type'],
      interestRate: json['interest_rate'],
      interestType: json['interest_type'],
      abbreviation: json['abbreviation'],
      description: json['description'],
      maxAmount: json['max_amount'],
      minAmount: json['min_mount'],
      term: json['term'],
      termPeriod: json['term_period'],
    );
  }

  final String? loanType, interestType, abbreviation, description;
  final int? maxAmount, minAmount, interestRate, termPeriod, term;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'loan_type': loanType,
      'interest_rate': interestType,
      'interest_type': interestType,
      'abbreviation': abbreviation,
      'description': description,
      'max_amount': maxAmount,
      'min_amount': minAmount,
      'term': term,
      'term_period': termPeriod
    };

    return map..removeWhere((key, value) => value == '' || value == null);
  }
}
