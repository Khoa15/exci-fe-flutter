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
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          }
          
          final Uri uri = Uri.parse(settings.name ?? '');
          if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'folder') {
            final folderId = uri.pathSegments[1];
            // Retrieve the FolderModel based on folderId or create a placeholder
            final folder = FolderModel(name: folderId, listWord: [
              WordModel(word: 'Apple', audio: 'https://api.dictionaryapi.dev/media/pronunciations/en/apple-us.mp3'), 
              WordModel(word: 'Banana', audio: 'https://api.dictionaryapi.dev/media/pronunciations/en/banana-us.mp3'), 
              WordModel(word: 'Yard', audio: 'https://api.dictionaryapi.dev/media/pronunciations/en/yard-us.mp3')]);

            return MaterialPageRoute(
              builder: (context) => WordListScreen(folder: folder),
            );
          }

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
