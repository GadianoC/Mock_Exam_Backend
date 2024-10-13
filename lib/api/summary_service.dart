import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_app/api/api_client.dart';
import 'package:file_picker/file_picker.dart';

class SummaryService {
  final ApiClient _apiClient = ApiClient();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> summarizeDocument(
    PlatformFile file,
    double summaryLength,
    int detailLevel,
  ) async {
    if (file.bytes != null) {
      Uint8List fileBytes = file.bytes!;
      final summary = await _apiClient.summarizeDocumentBytes(
        fileBytes,
        summaryLength,
        detailLevel,
        file.extension ?? 'txt',
      );
      return summary;
    } else {
      throw Exception('Error: document content not available');
    }
  }

  Future<void> storeSummary(String summary, String fileName) async {
    await firestore.collection('summaries').add({
      'fileName': fileName,
      'summary': summary,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSummaries() {
    return firestore.collection('summaries').snapshots();
  }

  void deleteSummary(String docId) {
    firestore.collection('summaries').doc(docId).delete();
  }
}
