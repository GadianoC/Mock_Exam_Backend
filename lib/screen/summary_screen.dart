import 'package:ai_app/api/summary_service.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({
    super.key,
    required this.summary,
    required this.fileName,
  });

  final String summary;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                summary,
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final summaryService = SummaryService();
                    await summaryService.storeSummary(summary, fileName);
                  },
                  child: const Text('Save Summary')),
            ],
          ),
        ),
      ),
    );
  }
}
