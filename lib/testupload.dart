import 'dart:io'; //ne utk File type
import 'package:path/path.dart' as path;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TestUpload extends StatefulWidget {
  const TestUpload({super.key});

  @override
  State<TestUpload> createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {
  //declare utk papar gambar
  String? imageUrl;

  //function upload
  uploadgambar1(String option) async {
    //instance firebase storage
    final firebaseStorage = FirebaseStorage.instance;
    //guna picker
    final picker = ImagePicker();

    //create handler to the image kita ambil dari image picker
    XFile? pickedImage;

    try {
      //code buka imagepicker
      if (option == 'camera') {
        pickedImage =
          await (picker.pickImage(source: ImageSource.camera));
      } else if (option == 'gallery') {
        pickedImage =
          await (picker.pickImage(source: ImageSource.gallery)); //casting
      }
      
      // sesudah kita pilih photo dari image picker, kita masukkan ke dalam file imageFile yg jenis File
      String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      //dapatkan pemission
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        //check kalau image pilih atau tak sebelum upload ke firebase storage
        if (imageFile.path.isNotEmpty) {
          // Uploading the selected image with some custom meta data

          Reference ref = firebaseStorage.ref().child('/').child(fileName);

          try {
            await ref.putFile(imageFile).whenComplete(() async {
              var downloadUrl = await ref.getDownloadURL();
              debugPrint('try to get URL here');
              debugPrint(downloadUrl);
              setState(() {
                imageUrl = downloadUrl;
              });
            });
          } catch (e) {
            debugPrint(e.toString());
          }
          //end upload
        } else {
          debugPrint('Tiada Image dipilih');
        }
        //end check
      }
      //end pemission

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //placeholder
              (imageUrl != null)
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl!),
                      radius: 50,
                    )
                  : const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.imgur.com/sUFH1Aq.png'),
                      radius: 50,
                    ),
              const SizedBox(
                height: 20.0,
              ),
              //button upload
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // set the background color
                ),
                child: const Text(
                  "Upload Image",
                ),
                onPressed: () {
                  //code
                  uploadgambar1('camera');
                },
              ),

              TextButton.icon(
                  label: const Text('Gallery'),
                  onPressed: () {
                    uploadgambar1('gallery');
                  },
                  icon: const Icon(Icons.camera))
            ],
          ),
        ),
      ),
    );
  }
}
