import 'package:flutter/material.dart';
import 'auth_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        secondaryHeaderColor: Colors.purpleAccent,
      ),
      home: AuthScreen()
    );
  }
}

