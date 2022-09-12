import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';


class Change extends StatefulWidget {
  const Change({Key? key}) : super(key: key);

  @override
  State<Change> createState() => ChangeState();
}

class ChangeState extends State<Change> {

  final emailcontroller = TextEditingController();
  final old_pass_controller = TextEditingController();
  final new_pass_controller = TextEditingController();

  Future<void> func2() async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyC0IFqa01K_zMGFHs_Hdnye3PsZWc6WUrk');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'idToken': authToken,
            'password': new_pass_controller.text,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch(error){throw error;}

    SharedPreferences pref2 = await SharedPreferences.getInstance();
    pref2.setString('password', new_pass_controller.text);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password Changed'),),);

    Navigator.pop(context);
    Navigator.pop(context);

  }

  Future<void> chk() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    String? email = pref1.getString('email') ;

    SharedPreferences pref2 = await SharedPreferences.getInstance();
    String? pass = pref2.getString('password') ;

    print(email);
    print(emailcontroller.text);
    print(pass);
    print(old_pass_controller.text);

    if(email==emailcontroller.text.toString() && pass==old_pass_controller.text.toString()){
      await func2();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Credentials'),),);
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/1234.jpg"),
                fit: BoxFit.cover,
              ),

            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 230,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Card(
                      color: Colors.white54,
                      elevation: 8.0,
                      child: Form(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                // SizedBox(
                                //   height: 10,
                                // ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'E-Mail'),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailcontroller,
                                ),
                                TextField(
                                  decoration: InputDecoration(labelText: 'Old Password'),
                                  obscureText: true,
                                  controller: old_pass_controller,


                                ),
                                TextField(
                                  decoration: InputDecoration(labelText: 'New Password'),
                                  obscureText: true,
                                  controller: new_pass_controller,

                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                  MaterialButton(
                                    child: Text('Submit Change'),
                                    onPressed: () async {
                                          await chk();
                                          emailcontroller.text = '';
                                          old_pass_controller.text = '';
                                          new_pass_controller.text = '';

                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
