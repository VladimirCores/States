import 'dart:async';
import '../../const/Action.dart';
import '../page.dart';

class SignoutPage extends Page {
  Timer _timer;
  int _counter = 3;

  SignoutPage():super() {
    _timer = new Timer.periodic(Duration(seconds:1), _handleTimerTick);
    dom.style.backgroundColor = "coral";
  }

  void render() {
    dom.text = "Go to Index in ${_counter}";
  }

  void destroy() {
    _timer.cancel();
    _timer = null;
    super.destroy();
  }

  void _handleTimerTick(Timer timer) {
    if(--_counter == 0)
      dispatchAction( Action.SIGNOUT_PAGE_TIMER_EXPIRED );
    else this.render();
  }
}