import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sabroso/global/common/toast.dart';
import 'package:sabroso/modules/home/models/recipe_model.dart';
import 'package:sabroso/modules/home/widgets/add_recipe_modal.dart';
import 'package:sabroso/modules/home/widgets/nav_bar.dart';
import 'package:sabroso/modules/home/widgets/recipe_tile.dart';
import 'package:sabroso/utils/AppColor.dart';

import '../../user_auth/widgets/login_modal.dart';

class HomeScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Recipe>> _fetchRecipes() {
    return _firestore.collection('recipes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.secondary),
        title: Text(
          "Discover",
          style: TextStyle(
              color: AppColor.secondary,
              fontWeight: FontWeight.w700,
              fontFamily: 'inter',
              fontSize: 25),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        actions: [
          //search bar left
          Container(
            margin: EdgeInsets.only(left: 16),
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/recipeDetails");
              },
              icon: Icon(Icons.search, color: AppColor.secondary, size: 30,),
            ),
          ),
        ],
      ),
      body: Stack(
        children:[
          StreamBuilder<List<Recipe>>(stream: _fetchRecipes(), builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text("No recipes found"));
            }
            else{
              List<Recipe> recipes = snapshot.data!;
              return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index){
                    Recipe recipe = recipes[index];
                    return RecipeTile(recipe: recipe, onTap: (){
                      Navigator.pushNamed(context, '/recipeDetails');
                    });
                  });
            }
          }),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 25, bottom: 30),
              child: FloatingActionButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    isScrollControlled: true,
                    builder: (context) {
                      return AddRecipeModal();
                    },
                  );
                },
                backgroundColor: AppColor.primarySoft,
                child: Icon(Icons.add, color: AppColor.secondary,),
              ),
            ),
          ),
          ]
      ),
    );
  }
}
