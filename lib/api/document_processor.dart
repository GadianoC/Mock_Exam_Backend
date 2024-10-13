import 'dart:convert';
import 'dart:typed_data';
import 'package:xml/xml.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusionPdf;
import 'package:docx_to_text/docx_to_text.dart';

Future<String> processDocument(
    List<int> fileBytes, String fileExtension) async {
  fileExtension = fileExtension.toLowerCase();
  switch (fileExtension) {
    case 'pdf':
      return processPdf(fileBytes);
    case 'xml':
      return processXml(fileBytes);
    case 'docx':
      return await processDocx(fileBytes);
    case 'txt':
      return processText(fileBytes);
    default:
      throw Exception('Unsupported file Extension: $fileExtension');
  }
}

String processPdf(List<int> filebytes) {
  syncfusionPdf.PdfDocument document =
      syncfusionPdf.PdfDocument(inputBytes: Uint8List.fromList(filebytes));

  syncfusionPdf.PdfTextExtractor extractor =
      syncfusionPdf.PdfTextExtractor(document);

  String extractedText = extractor.extractText();

  document.dispose();

  return extractedText.trim();
}

String processXml(List<int> fileBytes) {
  final xmlDoc = XmlDocument.parse(utf8.decode(fileBytes));
  final textElements = xmlDoc.findAllElements('text');
  String extractedText = '';
  for (final element in textElements) {
    extractedText += '${element.text.trim()}\n';
  }
  return extractedText;
}

Future<String> processDocx(List<int> fileBytes) async {
  final Uint8List byteData = Uint8List.fromList(fileBytes);

  final text = docxToText(byteData);
  return text.trim();
}

String processText(List<int> fileBytes) {
  return utf8.decode(fileBytes).trim();
}
