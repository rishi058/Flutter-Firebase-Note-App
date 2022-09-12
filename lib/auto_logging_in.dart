import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';


Future<void> save_logged_data(String email, String password) async {
  SharedPreferences pref1 = await SharedPreferences.getInstance();
  pref1.setString('email', email);

  SharedPreferences pref2 = await SharedPreferences.getInstance();
  pref2.setString('password', password);

  SharedPreferences pref3 = await SharedPreferences.getInstance();
  pref3.setBool('is_logged_in', true);

}

Future<void> auto() async {

  SharedPreferences pref1 = await SharedPreferences.getInstance();
  String? email = pref1.getString('email') ;

  SharedPreferences pref2 = await SharedPreferences.getInstance();
  String? pass = pref2.getString('password');

  await login(email!, pass!);
}

