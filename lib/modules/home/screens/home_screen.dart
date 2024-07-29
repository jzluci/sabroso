import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sabroso/global/common/toast.dart';
import 'package:sabroso/modules/home/widgets/nav_bar.dart';
import 'package:sabroso/utils/AppColor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              onPressed: () {},
              icon: Icon(Icons.search, color: AppColor.secondary, size: 30,),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Welcome to the home screen"),
          ),
          SizedBox(
            height: 30,
          ),
          //add new recipe button
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/newRecipe", (route) => false);
            },
            child: Container(
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "Add New Recipe",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
