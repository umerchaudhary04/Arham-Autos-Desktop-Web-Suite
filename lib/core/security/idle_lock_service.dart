import 'dart:async';
import 'package:flutter/services.dart';

class IdleLockService {
  Timer? _timer;
  int _timeoutMinutes = 5;
  final void Function() onLock;

  IdleLockService({required this.onLock}) {
    _startTimer();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    handleUserInteraction();
    return false;
  }

  void setTimeout(int minutes) {
    _timeoutMinutes = minutes;
    _resetTimer();
  }

  void handleUserInteraction() {
    _resetTimer();
  }

  void _startTimer() {
    _timer = Timer(Duration(minutes: _timeoutMinutes), () {
      onLock();
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void dispose() {
    _timer?.cancel();
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
  }
}
