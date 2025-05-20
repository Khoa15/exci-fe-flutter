// import 'package:exci_flutter/models/folder_model.dart';
import 'package:exci_flutter/screens/forgot_password_screen.dart';
import 'package:exci_flutter/screens/home_screen.dart';
import 'package:exci_flutter/screens/login_screen.dart';
import 'package:exci_flutter/screens/profile_screen.dart';
import 'package:exci_flutter/screens/signup_screen.dart';
import 'package:exci_flutter/screens/vocabulary_screen.dart';
import 'package:exci_flutter/screens/practise_word_list_screen.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/home': (context) => HomeScreen(),
          '/vocabulary': (context) => VocabularyScreen(),
          '/profile': (context) => ProfileScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          }

          final Uri uri = Uri.parse(settings.name ?? '');

          if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'folder') {
            final folderId = uri.pathSegments[1];
            try {
              return MaterialPageRoute(
                builder: (context) => WordListScreen(collectionId: int.parse(folderId)),
              );
            } catch (e) {
              return MaterialPageRoute(
                builder: (context) => HomeScreen(), //ErrorScreen(message: 'Invalid folder ID'),
              );
            }
          }

          return null;
        },
        
        title: 'Exci',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return authService.isLoggedIn ? HomeScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
