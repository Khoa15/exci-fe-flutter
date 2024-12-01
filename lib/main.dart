import 'package:exci_flutter/models/collection.dart';
// import 'package:exci_flutter/models/folder_model.dart';
import 'package:exci_flutter/models/word.dart';
import 'package:exci_flutter/screens/home_screen.dart';
import 'package:exci_flutter/screens/login_screen.dart';
import 'package:exci_flutter/screens/profile_screen.dart';
import 'package:exci_flutter/screens/signup_screen.dart';
import 'package:exci_flutter/screens/vocabulary_screen.dart';
import 'package:exci_flutter/screens/practise_word_list_screen.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

// Future main() async{
//   await dotenv.load(fileName: ".env");
//   runApp(const MyApp());
// }

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
          '/forgot-password': (context) => ProfileScreen(),
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

          // Add more conditions for other routes as needed

          return null; // Flutter will handle unknown routes
        },

        // onGenerateRoute: (settings) {
        //   if (settings.name == '/') {
        //     return MaterialPageRoute(builder: (context) => HomeScreen());
        //   }

        //   final Uri uri = Uri.parse(settings.name ?? '');
        //   if (uri.pathSegments.length == 2 &&
        //       uri.pathSegments.first == 'folder') {
        //     final folderId = uri.pathSegments[1];

        //     print(folderId);
        //     return MaterialPageRoute(
        //       builder: (context) => WordListScreen(collectionId: int.parse(folderId)),
        //     );
        //   }

        //   return null;
        // },
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
