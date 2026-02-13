class QuestionnaireModel {
  final String id;
  final String title;
  final String description;
  final List<QuestionModel> questions;

  QuestionnaireModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuestionModel.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionModel {
  final String id;
  final String text;
  final List<String> options;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
    };
  }
}