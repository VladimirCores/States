import 'dart:async';
import 'dart:math';

import 'package:dart_machine/dart_machine.dart';

main() {

	String STATE_INITIAL = "state_begins";

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

	dartMachine.addState( STATE_INITIAL );

	dartMachine.addState( STATE_LOADING );
	dartMachine.addState( STATE_LOADING_COMPLETE );
	dartMachine.addState( STATE_LOADING_FAILED );

	dartMachine.addState( STATE_PREPARE_MODEL );
	dartMachine.addState( STATE_PREPARE_CONTROLLER );
	dartMachine.addState( STATE_PREPARE_VIEW );
	dartMachine.addState( STATE_PREPARE_COMPLETE );
	dartMachine.addState( STATE_READY );

	dartMachine.addAction(
			STATE_INITIAL,
			STATE_LOADING,
			ACTION_LOADING_START,
			() {
				print("> CURRENT state: " + dartMachine.currentState());
				scheduleMicrotask(() {
					print("> \t END OF microtask queue -> state: " + dartMachine.currentState());
					dartMachine.performAction(
							Random.secure().nextBool()
							? ACTION_LOADING_COMPLETE
							: ACTION_LOADING_FAILED
					);
				});
			});

	dartMachine.addAction(
			STATE_LOADING,
			STATE_LOADING_COMPLETE,
			ACTION_LOADING_COMPLETE,
			() {
				print("> CURRENT state: " + dartMachine.currentState());
				scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + dartMachine.currentState()));
			}
	);

	dartMachine.addAction(
			STATE_LOADING,
			STATE_LOADING_FAILED,
			ACTION_LOADING_FAILED,
			() {
				print("> CURRENT state: " + dartMachine.currentState());
				scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + dartMachine.currentState()));
			}
	);

	dartMachine.performAction( ACTION_LOADING_START );

}
