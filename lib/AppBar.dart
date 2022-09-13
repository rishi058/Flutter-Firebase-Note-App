import 'package:fire_notes/CHANGE_PASS.dart';
import 'package:fire_notes/Engine.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screen.dart';
import 'about.dart';
import 'fire_notes.dart';
import 'Note_structure.dart';

class My_Drawer extends StatelessWidget {
  const My_Drawer({Key? key}) : super(key: key);

  Future<void> delete_all(BuildContext ctx) async {

    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
          'Do you want to delete all Note entries ?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () async {

              await get_all();

              while(temp.length!=0){
                await get_all();

                for(int i=0; i<temp.length; i++){
                  String id = temp[i].id;
                  await delete(id);
                  print(DateTime.now().toString());
                  print(temp.length);
                }
              }

              Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(builder: (context) {return FireNote();},),(route) => false);


              // while(true){
              //   if(temp.length!=0){continue;}
              //   else{
              //   }
              // }

            },
          ),
        ],
      ),
    );


  }

  Future<void> fun(BuildContext ctx) async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    pref1.remove('email');

    SharedPreferences pref2 = await SharedPreferences.getInstance();
    pref2.remove('password');

    SharedPreferences pref3 = await SharedPreferences.getInstance();
    pref3.remove('is_logged_in');

    temp.clear();

    Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(builder: (context) {return AuthScreen();},),(route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey.shade50,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Stack(
                  children: [

                    Container(
                      child: Image.asset(
                        'assets/images/33333.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: Positioned(
                       bottom: 0,
                        left: 85,
                        child: Container(
                          color: Colors.purpleAccent.shade100.withOpacity(0.5),
                          child: Text('Fire - Notes',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 50,
              ),

              Divider(),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {return Change();},),);

                },
                child: ListTile(
                  leading: Icon(Icons.password),
                  title: Text('Change Password'),
                ),
              ),

              Divider(),

              InkWell(
                onTap: () async {
                  await delete_all(context);
                },

                child: ListTile(
                  leading: Icon(Icons.delete_sweep),
                  title: Text('Delete All'),
                ),
              ),
              Divider(),

              InkWell(
                onTap: () async {
                  await fun(context);
                },

                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                ),
              ),


              Divider(),


              InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) {return About();},),);
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                ),
              ),

              Divider(),


            ],
          ),
        ),
      ),
    );
  }
}
