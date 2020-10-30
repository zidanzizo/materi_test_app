import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class LoginScreen extends StatefulWidget {
  static const route_name = '/login';
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _obscureText = true;
  var _isLoading = false;

  Map<String, String> _loginData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      //invalid
      return;
    }
    _formKey.currentState.save();
    print(_loginData['email']);
    print(_loginData['password']);
    // setState(() {
    //   _isLoading = true;
    // });
    await Provider.of<Auth>(context, listen: false).signIn(
      _loginData['email'],
      _loginData['password'],
    );
    // setState(() {
    //   _isLoading = false;
    // });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('AUTHENTICATION'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // width: deviceSize.width,
          // height: deviceSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 15),
                  child: Image.asset(
                    'assets/images/login.png',
                    height: deviceSize.height * 0.25,
                    width: deviceSize.width * 0.7,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Please input your credentials',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
                            contentPadding: EdgeInsets.fromLTRB(25, 20, 20, 10),
                            filled: true,
                            fillColor: Color(0xFFE7E7E7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                          },
                          onSaved: (value) {
                            _loginData['email'] = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _toggle,
                            ),
                            hintText: 'Password',
                            contentPadding: EdgeInsets.fromLTRB(25, 20, 20, 10),
                            filled: true,
                            fillColor: Color(0xFFE7E7E7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'password terlalu pendek';
                            }
                          },
                          onSaved: (value) {
                            _loginData['password'] = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Color(0xFF131E9E),
                          padding: EdgeInsets.all(17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
