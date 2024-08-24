import 'package:exci_flutter/models/user_model.dart';
import 'package:flutter/material.dart';

class RankScreen extends StatelessWidget {
  List<UserModel> users = [
    UserModel(id: '',accountType: 'standard', profilePictureUrl: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg', name: 'Khoa', email: '', password: ''),
    UserModel(id: '',accountType: 'standard', profilePictureUrl: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg', name: 'Khoa', email: '', password: ''),
    UserModel(id: '',accountType: 'standard', profilePictureUrl: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg', name: 'Khoa', email: '', password: ''),
    UserModel(id: '',accountType: 'standard', profilePictureUrl: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg', name: 'Khoa', email: '', password: ''),
    UserModel(id: '',accountType: 'standard', profilePictureUrl: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg', name: 'Khoa', email: '', password: ''),
  ];
  List<Color> top10Colors = [
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.yellowAccent,
  Colors.greenAccent,
  Colors.blueAccent,
  Colors.indigoAccent,
  Colors.purpleAccent,
  Colors.pinkAccent,
  Colors.tealAccent,
  Colors.limeAccent,
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xếp hạng'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final isTop10 = index < 3;
          final backgroundColor = isTop10 ? top10Colors[index] : Colors.white;
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3)
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              //color: backgroundColor,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePictureUrl),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      user.name,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Text(
                    10.toString(),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}