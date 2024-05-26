import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgot.dart';
import 'home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: const Color.fromARGB(255, 119, 118, 118), // Light grey color
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255), // Darker text for visibility
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextFormField(emailController, 'Email', 'Please enter a valid email'),
                        SizedBox(height: 20),
                        _buildTextFormField(passwordController, 'Password', 'Please enter valid password min. 6 character', obscureText: true),
                        SizedBox(height: 20),
                        _buildForgotPasswordButton(),
                        SizedBox(height: 10),
                        _buildLoginButton(),
                        SizedBox(height: 10),
                        _buildRegisterButton(),
                        SizedBox(height: 10),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          child: CircularProgressIndicator(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(TextEditingController controller, String hintText, String errorMessage, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: obscureText ? IconButton(
          icon: Icon(_isObscure3 ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isObscure3 = !_isObscure3),
        ) : null,
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        enabled: true,
        contentPadding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value!.isEmpty ? errorMessage : null,
      onSaved: (value) => controller.text = value!,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildForgotPasswordButton() {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Forgotpass())),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[900], // Background color
        foregroundColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(), // Button shape
        textStyle: TextStyle(
          fontSize: 16, // Smaller text size
          decoration: TextDecoration.underline,
        ),
      ),
      child: Text("Forgot Password ...."),
    );
  }

  Widget _buildLoginButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 5.0,
      height: 40,
      onPressed: () {
        setState(() => visible = true);
        signIn(emailController.text, passwordController.text);
      },
      child: Text("Login", style: TextStyle(fontSize: 20)),
      color: Colors.white,
    );
  }

  Widget _buildRegisterButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 5.0,
      height: 40,
      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register())),
      color: Color.fromARGB(255, 69, 115, 183),
      child: Text("Register Now", style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
