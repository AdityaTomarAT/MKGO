// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CONDITIONscreen extends StatefulWidget {
  const CONDITIONscreen({super.key});

  @override
  State<CONDITIONscreen> createState() => _CONDITIONscreenState();
}

final String url = Get.arguments[0];

class _CONDITIONscreenState extends State<CONDITIONscreen> {


  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse(url));

    @override
    void initState() {
      super.initState();
      print('Final Base Url: $url');
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close_outlined,
            color: Color(0xFF3954A4),
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
