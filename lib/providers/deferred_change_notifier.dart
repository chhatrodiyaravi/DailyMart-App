import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class DeferredChangeNotifier extends ChangeNotifier {
  void safeNotifyListeners() {
    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle) {
      notifyListeners();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
