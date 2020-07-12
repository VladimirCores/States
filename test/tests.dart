import 'dart:math';

import 'package:states/states.dart';
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

    States states = new States();

    setUp(() {
	    states.add( STATE_BEGINS );

	    states.add( STATE_LOADING );
	    states.add( STATE_LOADING_COMPLETE );
	    states.add( STATE_LOADING_FAILED );

	    states.add( STATE_PREPARE_MODEL );
	    states.add( STATE_PREPARE_CONTROLLER );
	    states.add( STATE_PREPARE_VIEW );
	    states.add( STATE_PREPARE_COMPLETE );
	    states.add( STATE_READY );

	    states.action(
			    STATE_BEGINS,
			    STATE_LOADING,
			    ACTION_LOADING_START,
			    () {
			    	print("> STATE_BEGINS transition to: " + states.current());
				    states.perform(
						    Random.secure().nextBool()
						    ? ACTION_LOADING_COMPLETE
						    : ACTION_LOADING_FAILED
				    );
			    });

	    states.action( STATE_LOADING, STATE_LOADING_COMPLETE, ACTION_LOADING_COMPLETE, () => print("> STATE_LOADING transition to: " + states.current()) );
	    states.action( STATE_LOADING, STATE_LOADING_FAILED, ACTION_LOADING_FAILED, () => print("> STATE_LOADING transition to: " + states.current()) );
    });

    test('1) Initial State:', () {
      expect(states.current(), STATE_BEGINS);
    });

    test('2) Trying to change state to STATE_LOADING:', () {
	    expect(states.change( STATE_LOADING ), true);
    });

    test('3) Current State should be STATE_LOADING:', () {
	    expect( states.current(), STATE_LOADING );
    });

    states.perform( ACTION_LOADING_START );
  });
}
