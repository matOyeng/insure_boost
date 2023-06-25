import 'package:flutter/material.dart';

class ChangePwdPage extends StatefulWidget {
  const ChangePwdPage({Key? key}) : super(key: key);

  @override
  _ChangePwdPageState createState() => _ChangePwdPageState();
}

class _ChangePwdPageState extends State<ChangePwdPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _new = '';
  void _submit() {}

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
      body: Container(
        margin: EdgeInsets.all(height * 0.05),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Old Password',
                  ),
                  // use the validator to return an error string (or null) based on the input text
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Old Password';
                    }
                    return null;
                  },
                  // update the state variable when the text changes
                  onChanged: (text) => setState(() => _name = text),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter New Password',
                  ),
                  // use the validator to return an error string (or null) based on the input text
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter New Password';
                    }
                    return null;
                  },
                  // update the state variable when the text changes
                  onChanged: (text) => setState(() => _name = text),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Verify New Password',
                  ),
                  // use the validator to return an error string (or null) based on the input text
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Verify New Password';
                    }
                    return null;
                  },
                  // update the state variable when the text changes
                  onChanged: (text) => setState(() => _name = text),
                ),
                SizedBox(
                  height: height * 0.10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                    primary: Colors.teal, // background
                    onPrimary: Colors.white, // foreground
                    elevation: 0,
                  ),
                  // only enable the button if the text is not empty
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                    primary: Colors.white, // background
                    onPrimary: Colors.teal, // foreground
                    elevation: 0,
                  ),
                  // only enable the button if the text is not empty
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
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
