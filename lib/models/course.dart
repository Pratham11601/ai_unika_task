class Course {
  String? id;
  String title;
  String description;
  String category;
  int lessons;
  int score;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.lessons,
    required this.score,
  });

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? lessons,
    int? score,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      lessons: lessons ?? this.lessons,
      score: score ?? this.score,
    );
  }

  // -----------------------
  // FROM JSON
  // -----------------------
  factory Course.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final title = (json['title'] ?? '') as String;
    final description = (json['description'] ?? '') as String;

    // Accept either 'category' or 'cat_id'
    final category = (json['category'] ?? json['cat_id'] ?? '') as String;

    final lessonsDynamic = json['lessons'];
    final lessons = lessonsDynamic is int
        ? lessonsDynamic
        : int.tryParse(lessonsDynamic?.toString() ?? '') ?? 0;

    final scoreDynamic = json['score'];
    final score = scoreDynamic is int
        ? scoreDynamic
        : int.tryParse(scoreDynamic?.toString() ?? '') ??
        (title.length * lessons);

    return Course(
      id: id,
      title: title,
      description: description,
      category: category,
      lessons: lessons,
      score: score,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'lessons': lessons,
      'score': score,
    };
  }
}
