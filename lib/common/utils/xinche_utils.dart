import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class XincheUtils {
  String retYMDTime() {
    DateTime now = DateTime.now();
    // 格式化日期
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate; // 输出: 日期: 2024-01-15
  }

  String? getOsSign() {
    String? sign;
    String str = 'APP|sLogin|' + retYMDTime();
    sign = sha1
        .convert(utf8.encode(md5.convert(utf8.encode(str)).toString()))
        .toString();
    return sign;
  }
}
