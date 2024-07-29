import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabroso/global/common/toast.dart';
import 'package:sabroso/modules/firestore_functions/read_data/get_username.dart';
import 'package:sabroso/utils/AppColor.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
                GetUserName(documentId: _firebaseAuth.currentUser!.uid),
            accountEmail: Text(
              _firebaseAuth.currentUser!.email.toString(),
              style: TextStyle(color: AppColor.secondary),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Icon(
                  Icons.account_circle,
                  color: AppColor.primarySoft,
                ),
              ),
            ),
            decoration: BoxDecoration(color: AppColor.primarySoft),
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red,),
            title: Text('Favorite Recipes', style: TextStyle(color: AppColor.primary),),
            onTap: () => print('fav'),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColor.primary,),
            title: Text('Settings', style: TextStyle(color: AppColor.primarySoft),),
            onTap: () => print('settings'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: AppColor.primary,),
            title: Text('Log out', style: TextStyle(color: AppColor.primary),),
            onTap: () => {
              _firebaseAuth.signOut(),
              Navigator.pushNamedAndRemoveUntil(
              context, "/welcome", (route) => false),
              showToast(message: "Signed Out"),
            },
          ),
        ],
      ),
    );
  }
}
