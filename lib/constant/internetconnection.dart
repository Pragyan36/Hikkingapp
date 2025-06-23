import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkTestWidget extends StatefulWidget {
  @override
  _NetworkTestWidgetState createState() => _NetworkTestWidgetState();
}

class _NetworkTestWidgetState extends State<NetworkTestWidget> {
  String _status = 'Checking...';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse('https://tile.openstreetmap.org/15/5272/12706.png'));
      setState(() {
        _status = response.statusCode == 200
            ? 'Internet OK'
            : 'Failed: ${response.statusCode}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_status));
  }
}
