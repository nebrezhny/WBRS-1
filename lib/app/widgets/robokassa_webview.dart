import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:xml/xml.dart';

import '../helper/global.dart';
import 'package:http/http.dart' as http;

class RobokassaWebview extends StatefulWidget {
  final String sum;
  const RobokassaWebview({super.key, required this.sum});

  @override
  State<RobokassaWebview> createState() => _RobokassaWebviewState();
}

class _RobokassaWebviewState extends State<RobokassaWebview> {
  var ctrl = WebViewController();
  int count = 0, _progress = 0;
  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features
    firebaseFirestore.collection('transaction').get().then((value) {
      count = value.docs.length;
    });
    firebaseFirestore.collection('transaction').doc(count.toString()).set({
      'id': count.toString(),
      'sum': widget.sum,
      'user_email': firebaseAuth.currentUser!.email,
      'user_id': firebaseAuth.currentUser!.uid,
      'time': DateTime.now().toString(),
    });
    String signature = md5.convert(utf8.encode('WBRS:1:$count:Grebat-kopat3102-')).toString();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            setState(() {
              _progress = progress;
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            print(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://auth.robokassa.ru/Merchant/Index.aspx?MerchantLogin=WBRS&OutSum=1&InvoiceID=$count&Description=test&SignatureValue=$signature'));

    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    ctrl = controller;
    // Enable virtual display.
  }

  @override
  void dispose() {
    super.dispose();
    ctrl = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (value, result) async {
        String signature_status = md5.convert(utf8.encode('WBRS:$count:Zhevat-kopat3103-')).toString();
        String resultCode = '';
        while(resultCode == '' || resultCode == '5') {
          var res = await http.post(
            Uri.parse('https://auth.robokassa.ru/Merchant/WebService/Service.asmx/OpStateExt?MerchantLogin=WBRS&InvoiceID=$count&Signature=$signature_status'),
            headers: <String, String>{
              'Content-Type': 'application/json'
            },
          );
          XmlDocument document = XmlDocument.parse(res.body);
          print(document);
          if(document.findAllElements('Code').first.innerText == '0') {
            print(document.findAllElements('Code'));
            resultCode = document.findAllElements('Code').elementAt(1).innerText;
          }
        }
        print(resultCode);
        if(resultCode == '100'){
          AndroidFlutterLocalNotificationsPlugin().show(0, 'Robokassa', 'Оплата прошла успешно', notificationDetails: const AndroidNotificationDetails('wbrs', 'wbrs', importance: Importance.max), payload: 'test');
        } else{
          AndroidFlutterLocalNotificationsPlugin().show(0, 'Robokassa', 'Оплата не прошла', notificationDetails: const AndroidNotificationDetails('wbrs', 'wbrs', importance: Importance.max), payload: 'test');
        }
      },
      child:
          _progress < 100
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              :      WebViewWidget(
            controller: ctrl,
          ),
    );
  }
}
