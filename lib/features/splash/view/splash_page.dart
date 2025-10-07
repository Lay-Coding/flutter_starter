import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rapid_framework/common/utils/app_utils.dart';
import 'package:flutter_rapid_framework/core/router/app_router.gr.dart';
import 'package:flutter_rapid_framework/features/webview/view/webview_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_manager.dart';
import '/core/router/app_router.dart';
import '/core/storage/storage_manager.dart';

/// 启动页
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;
  int _countdown = 3;
  Map? _config;

  @override
  void initState() {
    super.initState();
    _initApp();
    _getSplashConfig();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void _getSplashConfig() async {
    // GET 请求
    final response =
        await NetworkManager.get('/appSplashScreenPage/getAppSplashScreenPage');
    if (response.data['code'] == 200) {
      if (response.data['result'] != null) {
        StorageManager.setObject(
            'key-app-splash-setting', response.data['result']);
      }
    } else {
      AppUtils.showError(response.data['message']);
    }
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

  void _startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          // 倒计时结束后的操作
          _toMainAction();
        }
      });
    });
  }

  /// 初始化应用
  Future<void> _initApp() async {
    Map? objConfig = StorageManager.getObject('key-app-splash-setting');
    if (objConfig != null) {
      setState(() {
        _config = objConfig;
      });
    }
  }

  void _toDetailAction() {
    if (_config != null && _config!['isJump'] == '1') {
      //jumpMethod, 跳转方式(0浏览器 1应用内 2小程序)
      if (_config!['jumpMethod'] == '0' &&
          _config?['jumpAddress'] != null &&
          _config!['jumpAddress'].toString().isNotEmpty) {
        final paramsKeys = Map();
        paramsKeys['url'] = _config!['jumpAddress'];
        // AppNavigator.go(AppRouter.webview, extra: paramsKeys);
        // AppNavigator.push(WebviewRoute(url: 'aaaa'));
      } else if (_config!['jumpMethod'] == '1') {
      } else if (_config!['jumpMethod'] == '2') {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          GestureDetector(
            child: Image.network(_config != null &&
                    _config!['splashScreenPageImg'] != null
                ? _config!['splashScreenPageImg']
                : 'https://static.xinche365.cn/microShop/guanggao_02_750x1624@2x.png'),
            onTap: () => {_toDetailAction()},
          ),
          Positioned(
            top: 30 + MediaQuery.of(context).padding.top,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.30),
                  borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: GestureDetector(
                child: Text(
                  "广告$_countdown" + 's',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                onTap: () => {_toMainAction()},
              ),
            ),
          )
        ],
      ),
    );
  }
}
