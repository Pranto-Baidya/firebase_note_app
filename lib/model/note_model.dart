
class NoteModel{

  final String id;
  final String title;
  final String description;
  final String uid;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.uid,
    required this.category,
    this.createdAt,
    this.updatedAt
  });

  factory NoteModel.fromMap(String id, Map<String,dynamic> map){
    return NoteModel(
        id: id,
        title: map['title'] ?? " ",
        description: map['description'] ?? " ",
        uid: map['uid'] ?? " ",
        category: map['category'] ?? " ",
        createdAt: map['createdAt']?.toDate(),
        updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'title' : title,
      'description' : description,
      'uid' : uid,
      'category' : category,
      'createdAt' : createdAt,
      'updatedAt' : updatedAt
    };
  }
}