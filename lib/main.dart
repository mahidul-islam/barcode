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
  String result = '8901030740398';
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
            width: double.maxFinite,
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
  Future<String> getUPCDatabaseData(String code) async {
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

  Future<String> getSearchUPCData(String code) async {
    final dio = Dio();
    Response response = await dio.get(
      'http://www.searchupc.com/handlers/upcsearch.ashx',
      queryParameters: {
        'request_type': 3,
        'access_token': '99ED432B-94DB-490D-AF68-2CEAB5AA2330',
        'upc': code
      },
    );
    return response.data.toString();
  }

  Future<String> getOpenFoodFactData(String code) async {
    final dio = Dio();
    try {
      Response response = await dio.get(
        'https://world.openfoodfacts.org/api/v2/product/$code.json',
      );
      return response.data.toString();
    } catch (e) {
      debugPrint(':: ${e.toString()}');
      return e.toString();
    }
  }

  String upcDatabaseResult = 'NO DATA';
  String searchUPCResult = 'NO Data';
  String openFoodFactResult = 'NO Data';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'UPC database result: $upcDatabaseResult',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Search UPC result: $searchUPCResult',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Open Food Fact result: $openFoodFactResult',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            upcDatabaseResult = 'Loading';
            setState(() {});
            upcDatabaseResult = await getUPCDatabaseData(widget.code);
            setState(() {});
          },
          child: const Text('Fetch UPC database'),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            searchUPCResult = 'Loading';
            setState(() {});
            searchUPCResult = await getSearchUPCData(widget.code);
            setState(() {});
          },
          child: const Text('Fetch Search UPC Database'),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            openFoodFactResult = 'Loading';
            setState(() {});
            openFoodFactResult = await getOpenFoodFactData(widget.code);
            setState(() {});
          },
          child: const Text('Fetch Open Food Fact Data'),
        )
      ],
    );
  }
}
