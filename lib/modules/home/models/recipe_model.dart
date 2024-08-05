import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String title;
  String imageUrl;
  List<String> ingredients;
  List<String> instructions;
  String author;
  int time;
  int servings;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.author,
    required this.time,
    required this.servings,
  });

  // Factory method to create a Recipe from Firestore DocumentSnapshot
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Recipe(
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      instructions: List<String>.from(data['instructions'] ?? []),
      author: data['author'] ?? '',
      time: data['time'] ?? 0,
      servings: data['servings'] ?? 0,
    );
  }

  // Method to convert a Recipe object to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
      'author': author,
      'time': time,
      'servings': servings,
    };
  }
}
