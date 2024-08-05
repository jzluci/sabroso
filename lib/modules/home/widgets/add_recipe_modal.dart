import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sabroso/modules/firestore_functions/read_data/get_username.dart';
import 'package:sabroso/modules/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sabroso/modules/user_auth/widgets/form_container_widget.dart';
import 'package:sabroso/utils/AppColor.dart';
import '../models/recipe_model.dart';

class AddRecipeModal extends StatefulWidget {
  @override
  State<AddRecipeModal> createState() => _AddRecipeModalState();
}

class _AddRecipeModalState extends State<AddRecipeModal> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _servingsController = TextEditingController();
  List<TextEditingController> _ingredientsControllers = [];
  List<TextEditingController> _instructionsControllers = [];
  int _selectedTime = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _servingsController.dispose();
    _ingredientsControllers.forEach((controller) => controller.dispose());
    _instructionsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addIngredientField() {
    setState(() {
      _ingredientsControllers.add(TextEditingController());
    });
  }

  void _addInstructionField() {
    setState(() {
      _instructionsControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredientsControllers[index].dispose();
      _ingredientsControllers.removeAt(index);
    });
  }

  void _removeInstructionField(int index) {
    setState(() {
      _instructionsControllers[index].dispose();
      _instructionsControllers.removeAt(index);
    });
  }

  void _selectTime(int time) {
    setState(() {
      _selectedTime = time;
    });
  }

  Future<String> _getUsername(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists){
      return userDoc['username'];
    }
    else{
      return "Unknown user";
    }
  }

  void _addRecipe() async {
    String title = _titleController.text.trim();
    List<String> ingredients =
    _ingredientsControllers.map((controllers) => controllers.text).toList();
    List<String> instructions =
    _instructionsControllers.map((controller) => controller.text).toList();
    String imageUrl = '';
    String servings = _servingsController.text.trim();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String username = await _getUsername(uid);

    // Create a Recipe object
    Recipe recipe = Recipe(
      title: title,
      imageUrl: imageUrl,
      ingredients: ingredients,
      instructions: instructions,
      author: username,
      time: _selectedTime,
      servings: int.parse(servings),
    );

    // Add the Recipe object to Firestore
    await _firestore.collection('recipes').add(recipe.toFirestore());

    _instructionsControllers.forEach((element) => element.clear());
    _ingredientsControllers.forEach((element) => element.clear());
    _titleController.clear();
    _servingsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 85 / 100,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  margin: EdgeInsets.only(bottom: 20),
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              // header
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Text(
                  'Add Recipe',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Title field
              TextField(
                controller: _titleController,
                cursorColor: Colors.black,
                style: TextStyle(fontFamily: 'inter'),
                decoration: InputDecoration(
                  labelText: 'Recipe Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary)),
                ),
              ),
              //Ingredients field
              SizedBox(
                height: 10,
              ),
              Text(
                'Ingredients',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.bold),
              ),
              ..._ingredientsControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            labelText: 'Ingredient ${index + 1}'),
                      ),
                    ),
                    IconButton(
                        onPressed: () => _removeIngredientField(index),
                        icon: Icon(Icons.remove_circle))
                  ],
                );
              }).toList(),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _addIngredientField,
                child: Text(
                  'Add Ingredient',
                  style: TextStyle(color: AppColor.secondary),
                ),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.primarySoft)),
              ),
              SizedBox(
                height: 10,
              ),
              //Add steps to instructions *****
              Text(
                'Instructions',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.bold),
              ),
              ..._instructionsControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration:
                        InputDecoration(labelText: 'Step ${index + 1}'),
                      ),
                    ),
                    IconButton(
                        onPressed: () => _removeInstructionField(index),
                        icon: Icon(Icons.remove_circle))
                  ],
                );
              }).toList(),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _addInstructionField,
                child: Text(
                  'Add Step',
                  style: TextStyle(color: AppColor.secondary),
                ),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.primarySoft)),
              ),
              SizedBox(
                height: 16,
              ),
              //expected time to cook ****
              Text('Expected Time to Cook',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  int time = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.access_time,
                      color: _selectedTime >= time
                          ? AppColor.primarySoft
                          : Colors.grey,
                    ),
                    iconSize: 40,
                    onPressed: () => _selectTime(time),
                  );
                }),
              ),
              SizedBox(height: 16),
              // Section for expected servings yielded
              Text('Expected Servings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextField(
                controller: _servingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter number of servings',
                  hintText: 'e.g., 4',
                ),
              ),
              SizedBox(height: 16),
              //add recipe button ****
              ElevatedButton(
                onPressed: () {
                  _addRecipe();
                  Navigator.pop(context);
                },
                child: Text(
                  'Add Recipe',
                  style: TextStyle(color: AppColor.secondary),
                ),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.primarySoft)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
