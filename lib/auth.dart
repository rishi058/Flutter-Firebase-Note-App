import 'package:http/http.dart' as http;
import 'dart:convert';
import 'http_exception.dart';

String authToken = '';
String userId = '';
late bool logged;

Future<void> signup(String email, String password) async {
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC0IFqa01K_zMGFHs_Hdnye3PsZWc6WUrk');
try {
  final response = await http.post(
    url,
    body: json.encode(
      {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    ),
  );
  final responseData = json.decode(response.body);
  if (responseData['error'] != null) {
    throw HttpException(responseData['error']['message']);
  }
  authToken = responseData['idToken'];
  userId = responseData['localId'];
} catch(error){throw error;}

}

Future<void> login(String email, String password) async {

  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC0IFqa01K_zMGFHs_Hdnye3PsZWc6WUrk');

  try {
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      logged = false;
      throw HttpException(responseData['error']['message']);
    }
    else{
      logged = true;
    }
    authToken = responseData['idToken'];
    userId = responseData['localId'];
    print(userId);

  }catch(error){
    throw error;
  }

}


