import 'package:flutter/material.dart';
import '../models/sentiment_result.dart';
import '../services/sentiment_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  SentimentResult? _result;

  Future<void> _analyze() async {
    final text = _controller.text.trim();
    if (text.length < 3) {
      setState(() => _error = 'Minimal 3 karakter');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final value = await SentimentApi.predict(text);
      setState(() => _result = value);
    } catch (e) {
      setState(() => _error = 'Layanan belum dapat diakses');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SentiKampus'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Keadaan Input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Komentar layanan',
                hintText: 'Tulis minimal 3 karakter',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // Tombol Aksi (Loading handling)
            ElevatedButton(
              onPressed: _loading ? null : _analyze,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Analisis komentar'),
            ),
            const SizedBox(height: 16),

            // Keadaan Error
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Keadaan Success
            if (_result != null && !_loading)
              Card(
                elevation: 2,
                color: _result!.label.toLowerCase().contains('positif')
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '${_result!.label} ${(_result!.score * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _result!.label.toLowerCase().contains('positif')
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Apa arti hasil ini? Hasil ini adalah bantuan awal analisis sentimen, bukan keputusan final.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}