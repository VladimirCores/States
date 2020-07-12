import 'dart:async';
import 'dart:math';

import 'package:states/states.dart';
import 'package:test/test.dart';

void main() {
  group('States API Tests', () {

    String STATE_BEGINS = "state_begins";

    String STATE_LOADING = "state_loading";
    String STATE_LOADING_FAILED = "state_loading_failed";
    String STATE_LOADING_COMPLETE = "state_loading_complete";

    String ACTION_LOADING_START = "action_start_loading";
    String ACTION_LOADING_FAILED = "action_loading_failed";
    String ACTION_LOADING_COMPLETE = "action_loading_failed";

    States states = new States();

    setUp(() {
      states.add( STATE_BEGINS );
      states.add( STATE_LOADING );
	    states.add( STATE_LOADING_COMPLETE );
	    states.add( STATE_LOADING_FAILED );

	    states.action(
			    STATE_BEGINS,
			    STATE_LOADING,
			    ACTION_LOADING_START,
			    (StateAction action) {
			    	print("> From Action: STATE_BEGINS transition \n\t\tfrom: " + states.current());
            scheduleMicrotask(() {
              print("\t\tto: " + states.current());
            });
			    });

	    states.action( STATE_LOADING, STATE_LOADING_COMPLETE, ACTION_LOADING_COMPLETE,
              (StateAction action) => print("> ACTION_LOADING_COMPLETE transition from: " + states.current()) );
	    states.action( STATE_LOADING, STATE_LOADING_FAILED, ACTION_LOADING_FAILED,
              (StateAction action) => print("> ACTION_LOADING_FAILED transition from: " + states.current()) );
    });

    test('0) Add duplicated state (initial) is impossible, return false', () {
      expect( states.add( STATE_BEGINS ), isFalse );
    });

    test('1) Check Initial State, the one that was registered - STATE_BEGINS', () {
      expect( states.current(), STATE_BEGINS );
    });

    test('1.1) Check has state - STATE_LOADING', () {
      expect( states.has( state: STATE_LOADING ), isTrue );
      expect( states.has( state: "NOT_REGISTERED" ), isFalse );
    });

    test('1.2) Check has action - ACTION_LOADING_START', () {
      expect( states.has( action: ACTION_LOADING_START ), isTrue );
      expect( states.has( action: "ACTION_NOT_REGISTERED" ), isFalse );
    });

    test('2) Trying to change state to STATE_LOADING', () {
	    expect( states.change( STATE_LOADING ), isTrue );
    });

    test('3) Current state should be STATE_LOADING', () {
	    expect( states.current(), STATE_LOADING );
    });

    test('4) State can\'t be changed by action ACTION_LOADING_START, because current state is a final for action', () {
      expect( states.perform( ACTION_LOADING_START ), isFalse );
    });

    test('5) Change state by action ACTION_LOADING_COMPLETE or ACTION_LOADING_FAILED (by chance)', () {
      var nextBool = Random.secure().nextBool();
      expect( states.perform( nextBool ?
        ACTION_LOADING_COMPLETE :
        ACTION_LOADING_FAILED
      ), isTrue );
    });

    test('6) Reset states to initial (first registered)', () {
      states.reset();
      expect(states.current(), STATE_BEGINS );
    });
  });
}
