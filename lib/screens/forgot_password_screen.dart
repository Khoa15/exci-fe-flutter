import 'package:exci_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ForgotPasswordScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<_ForgotPasswordScreen>{
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),
          ElevatedButton(
            onPressed: () async {
              try{
                await authService.SendRequestForgotPassword(_emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã gửi yêu cầu tới ${_emailController.text}')),
                );
              }catch(error){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                );
              }
            },
            child: Text("Gửi")
          )
        ],
      ),
    );
  }

}