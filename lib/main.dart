import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sabroso/modules/app/splash_screen/splash_screen.dart';
import 'package:sabroso/modules/home/screens/home_screen.dart';
import 'package:sabroso/modules/home/screens/new_recipe_screen.dart';
import 'package:sabroso/modules/user_auth/screens/welcome_screen.dart';
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
        '/newRecipe': (context) => NewRecipeScreen(),
        '/welcome': (context) => WelcomePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}