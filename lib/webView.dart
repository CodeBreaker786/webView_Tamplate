import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mydogsid/widgets/show_flushbar.dart';

import 'common/config/general.dart';

class WebView extends StatefulWidget {
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  InAppWebViewController webView;

  String url = "";

  double progress = 0;

  bool canGoBack = false;

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == ConnectivityResult.none) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "OOPS!",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "NO INTERNET",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            Text("Please check your network connection."),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RaisedButton(
                                onPressed: () {
                                  if (!snapshot.hasData ||
                                      snapshot.data ==
                                          ConnectivityResult.none) {
                                    showSnackBar(
                                        context: context,
                                        value:
                                            'No Internet Connection. Please try again later');
                                  } else {
                                    showSnackBar(
                                        context: context, value: 'Loading...');
                                  }
                                },
                                child: Container(
                                    width: double.infinity,
                                    child: Center(child: Text("Try Again"))),
                                disabledColor: Colors.white70,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primaryColor: Colors.grey),
            title: appName,
            home: Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    webView.goBack();
                  },
                ),
                title: Row(
                  children: [
                    Container(
                      height: 30,
                      child: Image.asset(
                        'assets/images/dwellboxlogo.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Dwell Box',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: Container(
                      child: InAppWebView(
                        initialUrl: finalURL,
                        initialHeaders: {},
                        initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                        )),
                        onWebViewCreated: (InAppWebViewController controller) {
                          webView = controller;
                        },
                        onLoadStart: (InAppWebViewController controller,
                            String url) async {
                          setState(() {
                            this.url = url;
                          });
                        },
                        onLoadStop: (InAppWebViewController controller,
                            String url) async {
                          setState(() {
                            this.url = url;
                            isLoading = false;
                          });
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            isLoading = true;
                            this.progress = progress / 100;
                          });
                        },
                      ),
                    ),
                  ),
                  isLoading == true
                      ? SpinKitSquareCircle(
                          duration: Duration(seconds: 1),
                          color: Color(0xFF022335),
                          size: 50.0,
                        )
                      : Stack()
                ],
              ),
              // floatingActionButton: Padding(
              //   padding: const EdgeInsets.only(bottom: 85),
              //   child: MyFab(),
              // ),
            ),
          );
        }
      },
    );
  }
}
