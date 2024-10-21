import 'dart:typed_data';
import 'document_processor.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  Future<String> summarizeDocumentBytes(
    Uint8List fileBytes,
    double summaryLength,
    int detailLevel,
    String fileExtension,
  ) async {
    String documentContent = await processDocument(fileBytes, fileExtension);

    String prompt = 'Summarize the following text and keep summary within '
        '${summaryLength * 100}% of the original text length. Adjust the level of '
        'detail based on the provided detail level ($detailLevel):\n\n'
        '$documentContent';

    String summary = await callSummarizationApi(prompt);

    return summary;
  }

  Future<String> callSummarizationApi(String prompt) async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in environment variables');
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    try {
      final List<Content> contents = [
        Content.text(prompt),
      ];

      final response = await model.generateContent(contents);

      if (response.candidates.isNotEmpty) {
        String? generateText = response.candidates.first.text;

        return generateText?.trim() ?? 'No summary generated';
      } else {
        throw Exception('No candidates found in the response.');
      }
    } catch (e) {
      throw Exception('Failed to generate summary: ${e.toString()}');
    }
  }
}
