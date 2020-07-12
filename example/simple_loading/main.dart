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

	states.add( STATE_INITIAL );

	states.add( STATE_LOADING );
	states.add( STATE_LOADING_COMPLETE );
	states.add( STATE_LOADING_FAILED );

	states.add( STATE_PREPARE_MODEL );
	states.add( STATE_PREPARE_CONTROLLER );
	states.add( STATE_PREPARE_VIEW );
	states.add( STATE_PREPARE_COMPLETE );
	states.add( STATE_READY );

	states.action(
			STATE_INITIAL,
			STATE_LOADING,
			ACTION_LOADING_START,
			(StateAction action) {
				print("> CURRENT on ACTION_LOADING_START state: " + states.current());
				scheduleMicrotask(() {
					print("> \t END OF microtask queue -> state: " + states.current());
					var nextBool = Random.secure().nextBool();
					print("> \t\t next bool: " + nextBool.toString());
					states.perform(
							nextBool ?
							ACTION_LOADING_COMPLETE :
							ACTION_LOADING_FAILED
					);
				});
			});

	states.action(
			STATE_LOADING,
			STATE_LOADING_COMPLETE,
			ACTION_LOADING_COMPLETE,
			(StateAction action) {
				print("> CURRENT on ACTION_LOADING_COMPLETE - state: " + states.current());
				scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + states.current()));
			}
	);

	states.action(
			STATE_LOADING,
			STATE_LOADING_FAILED,
			ACTION_LOADING_FAILED,
			(StateAction action) {
				print("> CURRENT on ACTION_LOADING_FAILED state: " + states.current());
				scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + states.current()));
			}
	);

	states.perform( ACTION_LOADING_START );

}
