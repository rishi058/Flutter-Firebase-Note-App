import 'auto_logging_in.dart';
import 'package:fire_notes/fire_notes.dart';
import 'package:flutter/material.dart';
import 'http_exception.dart';
import 'auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  Future<void> check(BuildContext ctx) async {
    SharedPreferences pref3 = await SharedPreferences.getInstance();
    bool? flag = pref3.getBool('is_logged_in');

    if(flag!=null && flag==true){
      await auto();
      if(logged){
        Navigator.pushAndRemoveUntil(ctx,
            MaterialPageRoute(builder: (context) {return FireNote();},),
                (route) => false);
      }
    }
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;

  final _passwordController = TextEditingController();

  late AnimationController _controller;

  late Animation<Offset> _slideAnimation;

  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await login(_authData['email']! , _authData['password']!);
        if(logged){
          save_logged_data(_authData['email']!, _authData['password']!);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {return FireNote();},),
                  (route) => false);
        }

      } else {
        // Sign user up
        await signup(_authData['email']! , _authData['password']!);
        save_logged_data(_authData['email']!, _authData['password']!);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {return FireNote();},),
                (route) => false);

      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      print(error);
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    check(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
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
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Text('Fire - Notes', style: TextStyle(
                    fontSize: 50,
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 8.0,
                      child: AnimatedContainer(
                        color: Colors.white38,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: _authMode == AuthMode.Signup ? 320 : 260,
                        // height: _heightAnimation.value.height,
                        constraints:
                        BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
                        width: deviceSize.width * 0.75,
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'E-Mail'),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty || !value.contains('@')) {
                                      return 'Invalid email!';
                                    }
                                  },
                                  onSaved: (value) {
                                    _authData['email'] = value!;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'Password'),
                                  obscureText: true,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 5) {
                                      return 'Password is too short!';
                                    }
                                  },
                                  onSaved: (value) {
                                    _authData['password'] = value!;
                                  },
                                ),
                                AnimatedContainer(
                                  constraints: BoxConstraints(
                                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                                  ),
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                  child: FadeTransition(
                                    opacity: _opacityAnimation,
                                    child: SlideTransition(
                                      position: _slideAnimation,
                                      child: TextFormField(
                                        enabled: _authMode == AuthMode.Signup,
                                        decoration:
                                        InputDecoration(labelText: 'Confirm Password'),
                                        obscureText: true,
                                        validator: _authMode == AuthMode.Signup
                                            ? (value) {
                                          if (value != _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                        }
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (_isLoading)
                                  CircularProgressIndicator()
                                else
                                  MaterialButton(
                                    child:
                                    Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                                    onPressed: _submit,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                MaterialButton(
                                  child: Text(
                                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                                  onPressed: _switchAuthMode,
                                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

