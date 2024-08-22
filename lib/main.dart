import 'package:exci_flutter/models/folder_model.dart';
import 'package:exci_flutter/models/word_model.dart';
import 'package:exci_flutter/screens/home_screen.dart';
import 'package:exci_flutter/screens/login_screen.dart';
import 'package:exci_flutter/screens/profile_screen.dart';
import 'package:exci_flutter/screens/signup_screen.dart';
import 'package:exci_flutter/screens/vocabulary_screen.dart';
import 'package:exci_flutter/screens/word_list_screen.dart';
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
        },
        onGenerateRoute: (settings){
          // Handle '/' route
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          }
          
          // Handle '/folder/:id' route
          final Uri uri = Uri.parse(settings.name ?? '');
          if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'folder') {
            final folderId = uri.pathSegments[1];
            // Retrieve the FolderModel based on folderId or create a placeholder
            final folder = FolderModel(name: folderId, listWord: [WordModel(word: 'Apple')]);

            return MaterialPageRoute(
              builder: (context) => WordListScreen(folder: folder),
            );
          }

          // Return null if the route is not recognized
          return null;
        },
        title: 'Exci',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, _){
            return authService.isLoggedIn ? HomeScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
