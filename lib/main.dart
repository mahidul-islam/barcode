import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              setState(() {
                if (res is String) {
                  result = res;
                }
              });
            },
            child: const Text('Open Scanner'),
          ),
          const SizedBox(
            height: 20,
          ),
          Text('Barcode result: $result'),
          const SizedBox(
            height: 30,
          ),
          if (result != '')
            ApiCallWidget(
              code: result,
            ),
        ],
      ),
    );
  }
}

class ApiCallWidget extends StatefulWidget {
  const ApiCallWidget({super.key, required this.code});
  final String code;
  @override
  State<ApiCallWidget> createState() => _ApiCallWidgetState();
}

class _ApiCallWidgetState extends State<ApiCallWidget> {
  Future<String> getData(String code) async {
    final dio = Dio();
    Response response = await dio.get(
      'https://api.upcdatabase.org/product/$code',
      queryParameters: {
        'apikey': '672AD3E6317AFC5F4C34088B157632C9',
      },
      options: Options(
        headers: {"Authorization": "Bearer 672AD3E6317AFC5F4C34088B157632C9"},
      ),
    );
    return response.data.toString();
  }

  String data = 'NO DATA';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Api result: $data',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            data = 'Loading';
            data = await getData(widget.code);
            setState(() {});
          },
          child: const Text('Fetch'),
        )
      ],
    );
  }
}
