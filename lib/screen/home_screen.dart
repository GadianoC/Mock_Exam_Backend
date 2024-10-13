import 'package:ai_app/api/summary_service.dart';
import 'package:ai_app/screen/preview_screen.dart';
import 'package:ai_app/screen/summary_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SummaryService _summaryService = SummaryService();
  PlatformFile? file;
  double summaryLength = 0.5;
  double detailLevel = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Summarizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: pickFile,
                  child: const Text('Select File'),
                ),
                const SizedBox(height: 20),
                if (file != null) selectedFile(context),
                const SizedBox(height: 40),
                summaryLevelSlider(),
                const SizedBox(height: 20),
                detailLevelSlider(),
                const SizedBox(height: 20),
                summarizeButton(context),
              ],
            ),
          ),  
        ),
      ),
    );
  }

  ElevatedButton summarizeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final summary = await _summaryService.summarizeDocument(
          file!,
          summaryLength,
          detailLevel.toInt(),
        );
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SummaryScreen(summary: summary, fileName: file!.name),
            ),
          );
        }
      },
      child: const Text('Summarize'),
    );
  }

  Column detailLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Detail Level',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text(
                detailLevel.toStringAsPrecision(2),
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: detailLevel,
          label: detailLevel.toStringAsPrecision(2),
          onChanged: (double value) {
            setState(() {
              detailLevel = value;
            });
          },
        ),
      ],
    );
  }

  Column summaryLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Summary Length',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text(
                summaryLength.toStringAsPrecision(2),
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        Slider(
          min: 0.1,
          max: 1,
          divisions: 9,
          value: summaryLength,
          label: summaryLength.toStringAsPrecision(2),
          onChanged: (double value) {
            setState(() {
              summaryLength = value;
            });
          },
        ),
      ],
    );
  }

  Row selectedFile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('Selected File: ${file!.name}'),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(file: file!),
              ),
            );
          },
          child: const Text('Preview'),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                file = null;
              });
            },
            icon: const Icon(Icons.cancel))
      ],
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        file = result.files.single;
      });
    }
  }
}
