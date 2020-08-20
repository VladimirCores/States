import 'dart:async';
import 'dart:math';

import 'package:states/states.dart';

main() {
  String STATE_INITIAL = "state_initial";

  String STATE_LOADING = "state_loading";
  String STATE_LOADING_FAILED = "state_loading_failed";
  String STATE_LOADING_COMPLETE = "state_loading_complete";

  String STATE_PREPARE_MODEL = "state_prepare_model";
  String STATE_PREPARE_CONTROLLER = "state_prepare_controller";
  String STATE_PREPARE_VIEW = "state_prepare_view";
  String STATE_PREPARE_COMPLETE = "state_prepare_complete";
  String STATE_READY = "state_ready";

  String ACTION_LOADING_START = "action_start_loading";
  String ACTION_LOADING_FAILED = "action_loading_failed";
  String ACTION_LOADING_COMPLETE = "action_loading_complete";

  States states = new States();

  states.add(STATE_INITIAL);

  states.add(STATE_LOADING);
  states.add(STATE_LOADING_COMPLETE);
  states.add(STATE_LOADING_FAILED);

  states.add(STATE_PREPARE_MODEL);
  states.add(STATE_PREPARE_CONTROLLER);
  states.add(STATE_PREPARE_VIEW);
  states.add(STATE_PREPARE_COMPLETE);
  states.add(STATE_READY);

  states.when(
      from: STATE_INITIAL,
      to: STATE_LOADING,
      on: ACTION_LOADING_START,
      run: (StatesTransition transition) {
        printMessage("ACTION_LOADING_START", states.current, transition);
        scheduleMicrotask(() {
          var nextBool = Random.secure().nextBool();
          var nextAction =
              nextBool ? ACTION_LOADING_COMPLETE : ACTION_LOADING_FAILED;
          print(
              "> \t END OF microtask queue -> state: ${states.current} next action: ${nextAction}");
          states
              .run(nextBool ? ACTION_LOADING_COMPLETE : ACTION_LOADING_FAILED);
        });
      });

  states.when(
      from: STATE_LOADING,
      to: STATE_LOADING_COMPLETE,
      on: ACTION_LOADING_COMPLETE,
      run: (StatesTransition transition) {
        printMessage("ACTION_LOADING_COMPLETE", states.current, transition);
        scheduleMicrotask(() =>
            print("> \t END OF microtask queue -> state: " + states.current));
      });

  states.when(
      from: STATE_LOADING,
      to: STATE_LOADING_FAILED,
      on: ACTION_LOADING_FAILED,
      run: (StatesTransition transition) {
        printMessage("ACTION_LOADING_FAILED", states.current, transition);
        scheduleMicrotask(() =>
            print("> \t END OF microtask queue -> state: " + states.current));
      });

  print("> BEFORE LOADING START -> state: ${states.current}");
  print("> RUN -> ACTION_LOADING_START");
  states.run(ACTION_LOADING_START);
}

void printMessage(action, state, transition) {
  print(
      "> CURRENT -> $action \n\t\tstate: $state \n\t\ttransition: ${transition.toString()}");
}
