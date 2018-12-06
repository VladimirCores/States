import 'dart:math';

import 'package:dart_machine/dart_machine.dart';
import 'package:test/test.dart';

void main() {
  group('State Machine Test', () {

    String STATE_BEGINS = "state_begins";

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
    String ACTION_LOADING_COMPLETE = "action_loading_failed";

    DartMachine dartMachine = new DartMachine();

    setUp(() {
	    dartMachine.addState( STATE_BEGINS );

	    dartMachine.addState( STATE_LOADING );
	    dartMachine.addState( STATE_LOADING_COMPLETE );
	    dartMachine.addState( STATE_LOADING_FAILED );

	    dartMachine.addState( STATE_PREPARE_MODEL );
	    dartMachine.addState( STATE_PREPARE_CONTROLLER );
	    dartMachine.addState( STATE_PREPARE_VIEW );
	    dartMachine.addState( STATE_PREPARE_COMPLETE );
	    dartMachine.addState( STATE_READY );

	    dartMachine.addAction(
			    STATE_BEGINS,
			    STATE_LOADING,
			    ACTION_LOADING_START,
			    () {
			    	print("> STATE_BEGINS transition to: " + dartMachine.currentState());
				    dartMachine.performAction(
						    Random.secure().nextBool()
						    ? ACTION_LOADING_COMPLETE
						    : ACTION_LOADING_FAILED
				    );
			    });

	    dartMachine.addAction( STATE_LOADING, STATE_LOADING_COMPLETE, ACTION_LOADING_COMPLETE, () => print("> STATE_LOADING transition to: " + dartMachine.currentState()) );
	    dartMachine.addAction( STATE_LOADING, STATE_LOADING_FAILED, ACTION_LOADING_FAILED, () => print("> STATE_LOADING transition to: " + dartMachine.currentState()) );
    });

    test('1) Initial State:', () {
      expect(dartMachine.currentState(), STATE_BEGINS);
    });

    test('2) Trying to change state to STATE_LOADING:', () {
	    expect(dartMachine.changeState( STATE_LOADING ), true);
    });

    test('3) Current State should be STATE_LOADING:', () {
	    expect( dartMachine.currentState(), STATE_LOADING );
    });

    dartMachine.performAction( ACTION_LOADING_START );
  });
}
