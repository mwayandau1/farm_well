// ignore_for_file: use_build_context_synchronously

import 'package:farm_well/widgets/main_layout.dart';
import 'package:farm_well/screens/forgot_password.dart';
import 'package:farm_well/services/auth.dart';
import 'package:farm_well/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool _obscureText = true;

  Future<void> userLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainLayout()));
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      switch (e.code) {
        case 'user-not-found':
          message = "No User Found for that Email";
          break;
        case 'wrong-password':
          message = "Wrong Password Provided";
          break;
        case 'invalid-email':
          message = "Invalid Email Format";
          break;
        case 'user-disabled':
          message = "User Disabled";
          break;
        case 'too-many-requests':
          message = "Too Many Requests. Try Again Later";
          break;
        default:
          message = e.message ?? "An error occurred";
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            message,
            style: const TextStyle(fontSize: 18.0),
          )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Error: ${e.toString()}',
            style: const TextStyle(fontSize: 18.0),
          )));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildEmailField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: const Color(0xFFedf0f8),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter E-mail';
          } else if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'Please Enter a Valid Email';
          }
          return null;
        },
        controller: mailController,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Email",
            hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: const Color(0xFFedf0f8),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Password';
          }
          return null;
        },
        obscureText: _obscureText,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            hintStyle:
                const TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )),
      ),
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  email = mailController.text;
                  password = passwordController.text;
                });
                userLogin();
              }
            },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(30)),
        child: Center(
            child: !isLoading
                ? const Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  )),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return GestureDetector(
      onTap: () {
        AuthMethods().signInWithGoogle(context);
      },
      child: Image.asset(
        "images/google.png",
        height: 45,
        width: 45,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(
                color: Color(0xFF8c8e98),
                fontSize: 18.0,
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 5.0),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUp()));
          },
          child: const Text(
            "Sign up",
            style: TextStyle(
                color: Color(0xFF273671),
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/aifarm.jpg",
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailField(),
                    const SizedBox(height: 30.0),
                    _buildPasswordField(),
                    const SizedBox(height: 30.0),
                    _buildSignInButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
              },
              child: const Text("Forgot your password?",
                  style: TextStyle(
                      color: Color(0xFF8c8e98),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "or Log in with",
              style: TextStyle(
                  color: Color(0xFF273671),
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30.0),
            _buildGoogleSignInButton(),
            const SizedBox(height: 30.0),
            _buildSignUpText(),
          ],
        ),
      ),
    );
  }
}
