class FAQModel {
  FAQModel({this.question, this.answer});

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      question: json['question'],
      answer: json['answer'],
    );
  }

  final String? question, answer;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'question': question,
      'answer': answer,
    };

    return map..removeWhere((key, value) => value == '' || value == null);
  }
}
