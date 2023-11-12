import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class MyLoading {
  static void Function() showLoading(String text) {
    return BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black45,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void closeLoading() => BotToast.closeAllLoading();
}
