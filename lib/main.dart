import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController controllerGlobal;

  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.isCompleted) {
      return Future.value(false);
    } else {
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text("No back history item")),
      );
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: FutureBuilder<WebViewController>(
              future: _controller.future,
              builder: (BuildContext context,
                  AsyncSnapshot<WebViewController> controller) {
                if (controller.hasData) {
                  return IconButton(
                    onPressed: () {
                      controller.data?.goBack();
                    },
                    icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
                  );
                }
                return Container();
              }),
        ),
        body: SafeArea(
          child: WebView(
            initialUrl: "https://google.com",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
      ),
    );
  }
}
