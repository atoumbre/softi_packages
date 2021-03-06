import 'dart:async';

import 'package:get/get.dart';
import 'package:softi_common/src/core/base_controller.dart';

mixin TimerControllerMixin on BaseController {
  Duration get interval;

  final clock = DateTime.now().obs;
  Timer _timer;

  void stopTimer() {
    _timer.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(interval, (timer) {
      clock(DateTime.now());
    });
  }
}
