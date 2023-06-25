import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  final String url;
  const PDFViewerPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  bool done = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          actions: [
            IconButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading...')),
                );
                await downloadFileExample(widget.url);
              },
              icon: Icon(
                done ? Icons.download_done : Icons.download,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        body: SfPdfViewer.network(widget.url),
      ),
    );
  }

  Future<void> downloadFileExample(String url) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String name =
        await FirebaseStorage.instance.refFromURL(url).name.toString();
    File downloadToFile = File('${appDocDir.path}/${name}.pdf');
    print('${appDocDir.path}/${name}.pdf');

    try {
      TaskSnapshot task = await FirebaseStorage.instance
          .refFromURL(url)
          .writeToFile(downloadToFile)
          .whenComplete(() {
        setState(() {
          done = true;
        });
      });
      print(task);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
