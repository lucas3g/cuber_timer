import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/global_context.dart';

enum TypeSnack { success, error, warning, help }

class MySnackBar {
  final String title;
  final String message;
  final TypeSnack type;
  final int duration;

  MySnackBar({
    required this.title,
    required this.message,
    required this.type,
    this.duration = 4,
  }) {
    _showSnackBar();
  }

  Color _returnBackgroundColor() {
    if (type == TypeSnack.success) {
      return Colors.green.shade800;
    }
    if (type == TypeSnack.error) {
      return Colors.red.shade800;
    }
    if (type == TypeSnack.warning) {
      return Colors.yellow.shade900;
    }

    return Colors.blue.shade800;
  }

  String _returnLottieFile() {
    if (type == TypeSnack.success) {
      return "assets/images/success.json";
    }
    if (type == TypeSnack.error) {
      return "assets/images/failed.json";
    }
    if (type == TypeSnack.warning) {
      return "assets/images/warning.json";
    }

    return "assets/images/info.json";
  }

  _showSnackBar() {
    late SnackBar snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: Duration(seconds: duration),
      behavior: SnackBarBehavior.fixed,
      content: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            height: title.contains('internet') ||
                    message.contains('email contendo as informações')
                ? 110
                : message.contains('Para prosseguir com o cadastro')
                    ? 130
                    : message.contains('15 minutos')
                        ? 120
                        : type == TypeSnack.warning || type == TypeSnack.help
                            ? 100
                            : 90,
            decoration: BoxDecoration(
              color: _returnBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 70,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            message,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: type == TypeSnack.success
                ? -30
                : type == TypeSnack.help
                    ? 8
                    : 20,
            child: Lottie.asset(
              _returnLottieFile(),
              width: type == TypeSnack.success
                  ? 150
                  : type == TypeSnack.help
                      ? 65
                      : 50,
            ),
          ),
          Positioned(
            top: -5,
            right: -2,
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(GlobalContext.navigatorKey.currentContext!)
                    .hideCurrentSnackBar();
              },
              icon: const Icon(Icons.close),
              color: Colors.white,
            ),
          )
        ],
      ),
    );

    ScaffoldMessenger.of(GlobalContext.navigatorKey.currentContext!)
        .showSnackBar(snackBar);
  }
}
