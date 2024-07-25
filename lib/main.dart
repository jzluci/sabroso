import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sabroso/modules/app/splash_screen/splash_screen.dart';
import 'package:sabroso/modules/home/screens/home_screen.dart';
import 'package:sabroso/modules/home/screens/new_recipe_screen.dart';
import 'package:sabroso/modules/user_auth/screens/create_account_screen.dart';
import 'package:sabroso/modules/user_auth/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sabroso',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => CreateAccountScreen(),
        '/newRecipe': (context) => NewRecipeScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}