import 'package:aduanfbase/aduan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//tambah ne utk kita dapat firebase user
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
//----

class TambahAduan extends StatefulWidget {
  const TambahAduan({super.key});

  @override
  State<TambahAduan> createState() => _TambahAduanState();
}

class _TambahAduanState extends State<TambahAduan> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final tajukController = TextEditingController();

  final butiranController = TextEditingController();

  final pengaduController = TextEditingController();

  final jabatanController = TextEditingController();

  final jenisController = TextEditingController();

  final DateTime tarikhmasa = DateTime.now();

  //create
  Future<void> createAduan(String tajuk, String butiran, String? pengadu,
      String jabatan, String jenis, tarikhmasa) async {
    //step 1: Create Product
    Aduan(tajuk, butiran, pengadu!, jabatan, jenis, tarikhmasa);

    //step 2: Guna Firebase dan save
    try {
      await firestore.collection('aduans').doc().set({
        'tajuk': tajuk,
        'butiran': butiran,
        'pengadu': pengadu,
        'jabatan': jabatan,
        'jenis': jenis,
        'tarikhmasa': tarikhmasa
      });
      debugPrint('add product to firebase database');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String? _dropdownValue;

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }
  //---

  //declare global
  List<Map<String, dynamic>> jabatanArray = [
    {'id': 1, 'name': 'KKM'},
    {'id': 2, 'name': 'MOH'},
    {'id': 3, 'name': 'BPA'},
    {'id': 4, 'name': 'JPM'},
    {'id': 5, 'name': 'MAFI'}
  ];

  List<Map<String, dynamic>> _foundJabatan = [];
  List<Map<String, dynamic>> results = [];

  //function utk buka SearchDialogbox
  openDialogboxSearchjabatan() {
    debugPrint('Buka Dialogbox utk select jabatan');

    _foundJabatan = jabatanArray;

    void runFilter(String enteredKeyword, StateSetter setState) {
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        results = jabatanArray;
      } else {
        results = jabatanArray
            .where((jabatan) => jabatan['name']
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
        // we use the toLowerCase() method to make it case-insensitive

        setState(() {
          _foundJabatan = results;
        });
      }
    }

    //Alertdialogbox has it's own Statefulbuilder
    //so we have to wrap a Statefulbuilder if not the
    // Listview builder will not update even with setState
    Widget senaraiListJabatan = StatefulBuilder(
      builder: ((context, setState) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  runFilter(value, setState);
                },
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _foundJabatan.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundJabatan.length,
                        itemBuilder: (context, index) => ListTile(
                          key: ValueKey(_foundJabatan[index]['id']),
                          leading: Text(_foundJabatan[index]['id'].toString()),
                          title: Text(_foundJabatan[index]['name'].toString()),
                          onTap: () {
                            jabatanController.text =
                                _foundJabatan[index]['name'].toString();
                            Navigator.pop(context);
                          },
                        ),
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
              ),
            ],
          ),
        );
      }),
    );

    AlertDialog openSearch = AlertDialog(
      title: const Text('Search Jabatan'),
      content: SizedBox(width: 500, height: 400, child: senaraiListJabatan),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close')),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return openSearch;
        });
  }
  //end utk buka SearchDialogbox

  @override
  Widget build(BuildContext context) {
    //firebase user
    final firebaseUser = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Aduan'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text('Anda boleh membuat Aduan sini'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tajukController,
                    decoration: const InputDecoration(
                      labelText: 'Tajuk:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 3,
                    controller: butiranController,
                    decoration: const InputDecoration(
                      labelText: 'Butiran:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 60,
                    child: TextField(
                      controller: jabatanController,
                      decoration: InputDecoration(
                        labelText: 'Jabatan:',
                        border: const OutlineInputBorder(),
                        prefix: IconButton(
                            onPressed: () {
                              openDialogboxSearchjabatan();
                            },
                            icon: const Icon(Icons.search)),
                      ),
                    ),
                  ),
                ),

                //dropdown
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 60,
                    child: FormField(builder: (FormFieldState<String> state) {
                      return InputDecorator(

                        decoration: InputDecoration(
                            label: const Text('Jenis', style: TextStyle(fontSize: 21),),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        isEmpty: false,
                        
                        child: SizedBox(
                          width: 200,
                          height: 60,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.blue,),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Aduan', child: Text('Aduan')),
                                DropdownMenuItem(
                                    value: 'Bukan Aduan',
                                    child: Text('Bukan Aduan')),
                              ],
                              value: _dropdownValue,
                              onChanged: dropdownCallback,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Nota: Bukan Aduan adalah Pertanyaan, Penghargaan atau Cadangan'),
                ),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(onPressed: () {
                      //take photo
                    }, icon: const Icon(Icons.attach_file),
                    label: const Text('File'),
                    ),

                    TextButton.icon(onPressed: () {
                      //take photo
                    }, icon: const Icon(Icons.camera),
                    label: const Text('Photo'),
                    ),

                    TextButton.icon(onPressed: () {
                      //take photo
                    }, icon: const Icon(Icons.camera),
                    label: const Text('Video'),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(onPressed: () {
                      //take photo
                    }, icon: const Icon(Icons.audiotrack),
                    label: const Text('Audio'),
                    ),

                    TextButton.icon(onPressed: () {
                      //take photo
                    }, icon: const Icon(Icons.camera),
                    label: const Text('Misc'),
                    ),

                    TextButton.icon(onPressed: () {
                      //take photo
                    }, icon: const Icon(Icons.camera),
                    label: const Text('Misc'),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        //code to add
                        await createAduan(
                          tajukController.text,
                          butiranController.text,
                          firebaseUser?.uid,
                          jabatanController.text,
                          _dropdownValue!,
                          tarikhmasa,
                        ).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Tambah')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
