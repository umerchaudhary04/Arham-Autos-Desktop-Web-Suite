import 'dart:async';
import 'package:flutter/services.dart';

class IdleLockService {
  Timer? _timer;
  int _timeoutMinutes;
  final void Function() onLock;
  bool _isLocked = false;

  IdleLockService({required this.onLock, int timeoutMinutes = 10})
      : _timeoutMinutes = timeoutMinutes {
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
    if (_isLocked) return;
    _resetTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_timeoutMinutes <= 0) return;
    _timer = Timer(Duration(minutes: _timeoutMinutes), () {
      if (!_isLocked) {
        _isLocked = true;
        onLock();
      }
    });
  }

  void _resetTimer() {
    _startTimer();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
  }
}
