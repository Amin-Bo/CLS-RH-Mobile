import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewer extends StatefulWidget {
  var pdf;

  PdfViewer({Key? key, required this.pdf}) : super(key: key);

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
    );
  }
}
