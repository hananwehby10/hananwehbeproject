
import 'model/welcome_screen.dart';
import 'package:flutter/material.dart';


void main() {
  //to ensure that the Flutter framework's binding is initialized before executing certain operations, especially asynchronous ones, during app startup.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: WelcomeScreen(),
    );
  }

  // Replace this function with your actual asynchronous operation
  Future<String> fetchData() async {
    // Simulating a network call or any other asynchronous operation
    await Future.delayed(Duration(seconds: 2));
    return 'Data loaded successfully';
  }
}




