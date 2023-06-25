import 'package:flutter/material.dart';

class PasswordChangingOption extends StatefulWidget {
  const PasswordChangingOption({Key? key}) : super(key: key);

  @override
  _PasswordChangingOptionState createState() => _PasswordChangingOptionState();
}

class _PasswordChangingOptionState extends State<PasswordChangingOption> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _old = '';
  String _new = '';

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Change Password"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Can\'t be empty';
                              }
                              if (text.length < 4) {
                                return 'Too short';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter your old password',
                              // TODO: add errorHint
                            ),
                            onChanged: (text) {
                              print('First text field: $text');
                            },
                          ),
                          TextField(
                            onChanged: (text) {
                              print('First text field: $text');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.teal,
                      // onSurface: Colors.grey,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: _old.isNotEmpty && _new.isNotEmpty
                          ? Colors.teal
                          : Colors.teal[200],
                      // onSurface: Colors.grey,
                    ),
                    onPressed:
                        _old.isNotEmpty && _new.isNotEmpty ? _submit : null,
                    child: const Text('Submit'),
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Change Password",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {}
}
