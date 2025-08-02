class Question {
  final String text;
  final List<String> options;
  final int correctOptionsIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionsIndex,
  });
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        text: map["text"] ?? "",
        options: List<String>.from(map["options"] ?? []),
        correctOptionsIndex: map["correctOptionsIndex"] ?? 0);
  }
  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "options": options,
      "correctOptionsIndex": correctOptionsIndex,
    };
  }

  Question copywith(
      {String? text, List<String>? options, int? correctOptionsIndex}) {
    return Question(
      text: text ?? this.text,
      options: options ?? this.options,
      correctOptionsIndex: correctOptionsIndex ?? this.correctOptionsIndex,
    );
  }
}
