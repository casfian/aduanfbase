import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  //decalre
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email:',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password:',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  //signUp function sini
                  context.read<AuthenticationProvider>().signUp(
                      email: emailController.text,
                      password: passwordController.text);
                  Navigator.pop(context);
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}