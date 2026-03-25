import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class ContactSupportDebugScreen extends StatefulWidget {
  const ContactSupportDebugScreen({super.key});

  @override
  State<ContactSupportDebugScreen> createState() => _ContactSupportDebugScreenState();
}

class _ContactSupportDebugScreenState extends State<ContactSupportDebugScreen> {
  static const String _localDevHost = '192.168.5.235';
  static const String _localDevPort = '8000';
  final _messageController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _testDirectApiCall() async {
    setState(() {
      _loading = true;
      _result = 'Making API call...';
    });

    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://$_localDevHost:$_localDevPort/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer YOUR_ACTUAL_TOKEN_HERE',
        },
      ));
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ));

      final response = await dio.post(
        '/accounts/contact/',
        data: {
          'message': _messageController.text.trim(),
        },
      );

      setState(() {
        _result = 'SUCCESS!\nStatus: ${response.statusCode}\nData: ${response.data}';
        _loading = false;
      });

    } catch (e) {
      setState(() {
        if (e is DioException) {
          _result = 'ERROR!\nType: ${e.type}\nMessage: ${e.message}\nResponse: ${e.response?.data}';
        } else {
          _result = 'ERROR!\n$e';
        }
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Test Message',
                hintText: 'Enter a test message',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _testDirectApiCall,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Test Direct API Call'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _result.isEmpty ? 'Results will appear here...' : _result,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
