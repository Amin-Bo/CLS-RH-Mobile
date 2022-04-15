import 'dart:io';
import 'package:cls_rh/screens/components/download_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewer extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  var pdf;

  var fileName;
  PdfViewer({Key? key, required this.pdf, this.fileName = ""})
      : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fichier PDF'),
      ),
      body: const PDF(
        preventLinkNavigation: true,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ).cachedFromUrl(
        widget.pdf,
        placeholder: (double progress) =>
            Center(child: CircularProgressIndicator(value: progress / 100)),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => DownloadingDialog(
                    url: widget.pdf,
                    fileName: widget.fileName,
                  ));
        },
        child: const Icon(Icons.file_download),
      ),
    );
  }
}
