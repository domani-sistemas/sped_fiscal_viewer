import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class SpedPdfViewer extends StatelessWidget {
  final Future<Uint8List> Function(PdfPageFormat format) buildPdf;
  final String fileName;

  const SpedPdfViewer({
    super.key,
    required this.buildPdf,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Exportar/Compartilhar',
            onPressed: () async {
              final pdfBytes = await buildPdf(PdfPageFormat.a4);
              await Printing.sharePdf(
                bytes: pdfBytes,
                filename: fileName,
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: buildPdf,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        maxPageWidth: 700,
      ),
    );
  }
}
