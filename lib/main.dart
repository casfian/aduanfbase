import 'package:aduanfbase/home.dart';
import 'package:aduanfbase/login.dart';
import 'package:aduanfbase/testsearch.dart';
import 'package:aduanfbase/testupload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; //step 2 add provider
import 'authentication.dart'; //step 3 tambah ne
import 'package:firebase_auth/firebase_auth.dart'; //step 4 tambah ne


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    //step 1 tambah Multiprovider
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aduan Fbase',
        home: TestSearch(),
      ),
    );
  }
}

//class ne utk check dia dah login atau tak
class Authenticate extends StatelessWidget {
  const Authenticate({super.key});
  
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    // kalau user ada (user bukan kosong aka null) maka maksudnya dah login
    if (firebaseUser != null) {
      return const Home(); //dan kita suruh dia gi page Home
    }
    // kalau tak suruh dia login
    return Login();
  }
}
