import 'package:cloud_firestore/cloud_firestore.dart';

// class Updates {
//   String title;
//   String descreption;
//   Updates({required this.title, required this.descreption});

//   factory Updates.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map<String, dynamic>;

//     return Updates(
//       title: data['description'] ?? '',
//       descreption: data['imageurl'] ?? '',
//     );
//   }
// }

class PostModel {
  final String id;
  final String title;
  final String? url;
  final String description;
  final DateTime date;
  final List<String> likes;

  PostModel({
    required this.id,
    required this.likes,
    this.url,
    required this.title,
    required this.description,
    required this.date,
  });

  // دالة لتحويل بيانات Firebase إلى Model
  factory PostModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return PostModel(
      id: documentId,
      likes: List<String>.from(data["likes"] ?? []),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      date: (data['date'] as Timestamp)
          .toDate(), // تحويل Timestamp إلى DateTime
    );
  }
}
