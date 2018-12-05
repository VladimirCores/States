import 'dart:async';
import 'dart:math';

import 'package:state_machine/state_machine.dart';

main() {

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

	StateMachine stateMachine = new StateMachine();

	stateMachine.addState( STATE_BEGINS );

	stateMachine.addState( STATE_LOADING );
	stateMachine.addState( STATE_LOADING_COMPLETE );
	stateMachine.addState( STATE_LOADING_FAILED );

	stateMachine.addState( STATE_PREPARE_MODEL );
	stateMachine.addState( STATE_PREPARE_CONTROLLER );
	stateMachine.addState( STATE_PREPARE_VIEW );
	stateMachine.addState( STATE_PREPARE_COMPLETE );
	stateMachine.addState( STATE_READY );

	stateMachine.addAction(
			STATE_BEGINS,
			STATE_LOADING,
			ACTION_LOADING_START,
			() {
				print("> CURRENT state: " + stateMachine.currentState());
				scheduleMicrotask(() {
					print("> \t END OF microtask queue -> state: " + stateMachine.currentState());
					stateMachine.performAction(
							Random.secure().nextBool()
							? ACTION_LOADING_COMPLETE
							: ACTION_LOADING_FAILED
					);
				});
			});

	stateMachine.addAction(
			STATE_LOADING,
			STATE_LOADING_COMPLETE,
			ACTION_LOADING_COMPLETE,
			() {
				print("> CURRENT state: " + stateMachine.currentState());
				scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + stateMachine.currentState()));
			}
	);

	stateMachine.addAction(
			STATE_LOADING,
			STATE_LOADING_FAILED,
			ACTION_LOADING_FAILED,
			() {
				print("> CURRENT state: " + stateMachine.currentState());
				scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + stateMachine.currentState()));
			}
	);

	stateMachine.performAction( ACTION_LOADING_START );

}
