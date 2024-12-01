import 'package:exci_flutter/models/user.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RankScreen extends StatefulWidget {
  @override
  RankScreenState createState() => RankScreenState();
}

class RankScreenState extends State<RankScreen>{
  bool _isLoading = true;
  late User? _user;
  late List<UserRank>? _listUserRank;
  @override
  void initState(){
    super.initState();

    _loadListRankUsers();
  }
  Future<void> _loadUser() async {
    User? user = await getUser();
    setState(() {
      _user = user;
    });
  }
  void _loadListRankUsers()async{
    try{
      await _loadUser();
      var result = await _user?.GetListRank();
      setState(() {
        _listUserRank = result;
        _isLoading = false;
      });
    }catch(error){
        print(error);
    };

  }
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
      body: 
        _isLoading || _listUserRank == null ? Center(child: CircularProgressIndicator())
        :
      ListView.builder(
        itemCount: _listUserRank?.length,
        itemBuilder: (context, index) {
          final user = _listUserRank?[index];
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
                        offset: Offset(0, 3))
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                //color: backgroundColor,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(children: [
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(user.// profilePictureUrl),
                  // ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      user!.username,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Text(
                    //10.toString(),
                    user.memory_stat.toString(),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ]),
              ));
        },
      ),
    );
  }
}