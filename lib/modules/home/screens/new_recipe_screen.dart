import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabroso/global/common/toast.dart';

class NewRecipeScreen extends StatefulWidget {
  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final _firestore = FirebaseFirestore.instance;
  String title = '';
  String ingredients = '';
  String instructions = '';
  String imageUrl = '';
  String user = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: InputDecoration(
                hintText: 'Recipe Title',
              ),
            ),
            TextField(
              onChanged: (value) {
                ingredients = value;
              },
              decoration: InputDecoration(
                hintText: 'Ingredients',
              ),
            ),
            TextField(
              onChanged: (value) {
                instructions = value;
              },
              decoration: InputDecoration(
                hintText: 'Instructions',
              ),
            ),
            TextField(
              onChanged: (value) {
                imageUrl = value;
              },
              decoration: InputDecoration(
                hintText: 'Image URL',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('recipes').add({
                  'title': title,
                  'ingredients': ingredients,
                  'instructions': instructions,
                  'imageUrl': imageUrl,
                });
                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                showToast(message: "Recipe Successfully Created!");
              },
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
