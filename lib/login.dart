import 'package:aduanfbase/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';

class Login extends StatelessWidget {
  Login({super.key});

  //declare
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text('Selamat Datang. Sila Register dulu, Baru Login'),
              const SizedBox(
                height: 20,
              ),
              Image.network(
                  'https://www.pcb.gov.my/images/logo/header_banner_bm.png'),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      //signIn function sini
                      context.read<AuthenticationProvider>().signIn(
                          email: emailController.text,
                          password: passwordController.text);
                    },
                    child: const Text('Login')),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: const Text('Register')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
