import 'package:flutter/material.dart';
import '../screens/services/auth_service.dart'; // Import your updated auth service

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  bool _isTesting = false;
  List<String> _testResults = [];

  void _addTestResult(String result) {
    setState(() {
      _testResults.add(result);
    });
  }

  void _clearResults() {
    setState(() {
      _testResults.clear();
    });
  }

  Future<void> _testSingleConnection() async {
    setState(() {
      _isTesting = true;
      _testResults.clear();
    });

    _addTestResult('🚀 Starting connection test...');
    
    bool isConnected = await AuthService.testConnection();
    
    if (isConnected) {
      _addTestResult('✅ Connection successful!');
    } else {
      _addTestResult('❌ Connection failed!');
    }

    setState(() {
      _isTesting = false;
    });
  }

  Future<void> _testMultipleConnections() async {
    setState(() {
      _isTesting = true;
      _testResults.clear();
    });

    _addTestResult('🧪 Testing multiple URLs...');
    
    await AuthService.testMultipleUrls();
    
    _addTestResult('✅ Multiple URL test completed! Check console for detailed results.');

    setState(() {
      _isTesting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Test'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current URL Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current API URL:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'http://192.168.18.233:8000/api', // Update sesuai URL Anda
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Test Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTesting ? null : _testSingleConnection,
                    icon: const Icon(Icons.network_check),
                    label: const Text('Test Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTesting ? null : _testMultipleConnections,
                    icon: const Icon(Icons.search),
                    label: const Text('Test Multiple'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Clear Button
            ElevatedButton.icon(
              onPressed: _clearResults,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Results'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Loading Indicator
            if (_isTesting)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),

            // Test Results
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Results:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _testResults.isEmpty
                          ? const Center(
                              child: Text(
                                'No test results yet.\nClick "Test Connection" to start.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _testResults.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    _testResults[index],
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 Troubleshooting Steps:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Pastikan Laravel server running: php artisan serve\n'
                    '2. Check IP address komputer: ipconfig (Windows) / ifconfig (Mac/Linux)\n'
                    '3. Pastikan port 8000 terbuka\n'
                    '4. Test di browser: http://192.168.18.233:8000/api/test\n'
                    '5. Pastikan device di network yang sama',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}