import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/storage_manager.dart';

class WebviewPage extends ConsumerStatefulWidget {
  final String url;

  const WebviewPage({super.key, required this.url});

  @override
  ConsumerState<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends ConsumerState<WebviewPage> {
  late final WebViewController controller;
  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
        setState(() {
          _progress = progress / 100.0;
        });
      },
      onPageStarted: (String url) {
        setState(() {
          _progress = 0.0;
          _isLoading = true;
        });
      },
      onPageFinished: (String url) {
        setState(() {
          _progress = 1.0;
          _isLoading = false;
        });
      },
      onHttpError: (HttpResponseError error) {
        setState(() {
          _isLoading = false;
        });
      },
      onWebResourceError: (WebResourceError error) {
        setState(() {
          _isLoading = false;
        });
      },
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ));
    controller.loadRequest(Uri.parse(widget.url));
  }

  void _toMainAction() async {
    // 检查登录状态并跳转
    final isLoggedIn = await StorageManager.isLoggedIn();
    if (!mounted) return;

    // 检查登录状态并跳转
    print('倒计时结束');
    if (isLoggedIn) {
      AppNavigator.toHome();
    } else {
      AppNavigator.toLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            _toMainAction();
          },
        ),
      ),
      body: Column(
        children: [
          // 线性进度条
          if (_isLoading || _progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),

          // WebView
          Expanded(
            child: WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}
