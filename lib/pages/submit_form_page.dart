import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/api/submission_api.dart';

class SubmitFormPage extends StatefulWidget {
  const SubmitFormPage({Key? key}) : super(key: key);

  @override
  _SubmitFormPageState createState() => _SubmitFormPageState();
}

class _SubmitFormPageState extends State<SubmitFormPage> {
  late String title;
  late String email;
  late String detail;
  late String currentDate;
  late String author;
  late DateTime date;
  late IconData icon;
  late FilePickerResult result;
  UploadTask? task;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    date = DateTime.now();
    currentDate = date.toString();
    author = FirebaseAuth.instance.currentUser!.uid;
    icon = Icons.upload;
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      maxLength: 20,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Title is Required';
        }

        return null;
      },
      onSaved: (value) {
        title = value!;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (value) {
        email = value!;
      },
    );
  }

  Widget _builDetail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Detail'),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Detail is Required';
        }

        return null;
      },
      onSaved: (value) {
        detail = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('Please complete the information of your submission'),
                SizedBox(height: 20),
                _buildName(),
                _buildEmail(),
                _builDetail(),
                SizedBox(height: 100),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      side: BorderSide(color: Colors.teal, width: 2),
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                    primary: Colors.teal, // background
                    backgroundColor: Colors.white, // foreground
                    elevation: 0,
                  ),
                  onPressed: () async {
                    result = (await FilePicker.platform.pickFiles(
                      withData: true,
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    ))!;
                    if (result != null) {
                      setState(() {
                        icon = Icons.download_done;
                      });
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 250,
                    child: Icon(
                      icon,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                    primary: Colors.white, // background
                    backgroundColor: icon != Icons.download_done
                        ? Colors.grey
                        : Colors.teal, // foreground
                    elevation: 0,
                  ),
                  onPressed: icon != Icons.download_done
                      ? null
                      : () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          _formKey.currentState!.save();

                          submitFile();

                          Navigator.pop(context);

                          //Send to API
                        },
                  child: Container(
                    height: 30,
                    width: 250,
                    child: Center(child: Text('Submit')),
                  ),
                ),
                SizedBox(height: 20),
                Text(currentDate),
                Text(author),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future submitFile() async {
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref('submission/$author/$fileName')
          .putData(fileBytes!);
      String url = await taskSnapshot.ref.getDownloadURL();
      await SubmissionApi()
          .addFileToStore(title, author, date, email, detail, '', url);
    }
  }
}
