import 'package:aduanfbase/tambahaduan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    //firebase user
    final firebaseUser = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Senarai Aduan'),
        actions: [
          IconButton(
              onPressed: () async {
                //code
                await context.read<AuthenticationProvider>().signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue, size: 30,),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('User Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await context.read<AuthenticationProvider>().signOut();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          initialData: null, //data awal kita
          stream: FirebaseFirestore.instance
              .collection('aduans')
              .where('pengadu', isEqualTo: firebaseUser?.uid)
              .snapshots(), //sumber data kita
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(data['tajuk']),
                    subtitle: Text(data['jabatan']),
                  ),
                );
              }).toList(),
            );
          } //paparkan data kita
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //code
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const TambahAduan()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
