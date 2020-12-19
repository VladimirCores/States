import 'dart:async';
import 'dart:math';

import 'package:states/states.dart';
import 'package:test/test.dart';

void main() {
  group('States API Tests', () {
    String STATE_INITIAL = "state_initial";

    String STATE_LOADING = "state_loading";
    String STATE_LOADING_FAILED = "state_loading_failed";
    String STATE_LOADING_COMPLETE = "state_loading_complete";

    String ACTION_LOADING_START = "action_start_loading";
    String ACTION_LOADING_FAILED = "action_loading_failed";
    String ACTION_LOADING_COMPLETE = "action_loading_complete";

    String ACTION_RETRY = "action_reset";

    States states = new States();

    setUp(() {
      states.add(STATE_INITIAL);

      states.add(STATE_LOADING);
      states.add(STATE_LOADING_COMPLETE);
      states.add(STATE_LOADING_FAILED);

      states
        ..when(
          at: STATE_INITIAL,
          to: STATE_LOADING,
          on: ACTION_LOADING_START,
          handler: (StatesTransition transition) {
            print("> From Action: STATE_BEGINS transition \n\t\tfrom: " +
                states.current);
            scheduleMicrotask(() {
              print("\t\tto: " + states.current);
            });
          }
        )
        ..when(
          at: STATE_LOADING,
          to: STATE_LOADING_COMPLETE,
          on: ACTION_LOADING_COMPLETE,
          handler: (StatesTransition transition) => print(
            "> ACTION_LOADING_COMPLETE transition from: " + states.current)
        )
        ..when(
          at: STATE_LOADING,
          to: STATE_LOADING_FAILED,
          on: ACTION_LOADING_FAILED,
          handler: (StatesTransition transition) => print(
            "> ACTION_LOADING_FAILED transition from: " + states.current)
        )
        ..when(
          at: STATE_LOADING_FAILED,
          to: STATE_LOADING,
          on: ACTION_RETRY
        );
    });

    test('0) Add duplicated state (initial) is impossible, return null', () {
      expect(states.add(STATE_INITIAL), isNull);
    });

    test('1) Check for Initial State - STATE_INITIAL', () {
      expect(states.current, STATE_INITIAL);
    });

    test('1.1) Check has state - STATE_LOADING', () {
      expect(states.has(state: STATE_LOADING), isTrue);
      expect(states.has(state: "NOT_REGISTERED"), isFalse);
    });

    test('1.2) Check has action - ACTION_LOADING_START', () {
      expect(states.has(action: ACTION_LOADING_START), isTrue);
      expect(states.has(action: "ACTION_NOT_REGISTERED"), isFalse);
    });

    test('2) Trying to change state to STATE_LOADING', () {
      expect(states.change(to: STATE_LOADING), isTrue);
    });

    test('3) Current state should be STATE_LOADING', () {
      expect(states.current, STATE_LOADING);
    });

    test(
        '4) State can\'t be changed by action ACTION_LOADING_START, because current state is a final for action',
        () {
      expect(states.execute(ACTION_LOADING_START), isFalse);
    });

    test('5) Change state by action ACTION_LOADING_FAILED', () {
      expect(states.current, STATE_LOADING);
      expect(states.execute(ACTION_LOADING_FAILED), isTrue);
      expect(states.current, STATE_LOADING_FAILED);
    });

    test('6) Extend state action with additional handler', () {
      expect(states.on(ACTION_RETRY, (transition) {
        expect(transition, isNotNull);
        print("> ACTION_RETRY transition from: ${states.current} to ${transition.to}");
      }), isTrue);
      expect(states.on('UNREGISTERED_ACTION', (transition) {}), isFalse);
      expect(states.execute(ACTION_RETRY), isTrue);
      expect(states.current, STATE_LOADING);
    });

    test('7) Complete loading with additional handler on ACTION_LOADING_COMPLETE', () {
      expect(states.execute(ACTION_RETRY), isFalse);
      expect(states.on(ACTION_LOADING_COMPLETE, (transition) {
        expect(transition, isNotNull);
        print("> ACTION_LOADING_COMPLETE transition from: ${states.current} to ${transition.to}");
      }), isTrue);
      expect(states.execute(ACTION_LOADING_COMPLETE), isTrue);
      expect(states.current, STATE_LOADING_COMPLETE);
    });

    test('8) Reset states to initial (first registered)', () {
      states.reset();
      expect(states.current, STATE_INITIAL);
    });
  });
}
