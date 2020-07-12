# States - Finite State Machine for Dart v0.1.0

A library for Dart developers.

	IStates {
		
		/**
		 * What is the current state?
		 * @return The current state.
		 */
		String current();
		
		/**
		 * Does an action or a state exist in the state machine?
		 * @param action The action in question.
		 * @param state The state in question.
		 * @param conform The state in question.
		 * @return True if the action or state exists, false if it does not.
		 */
		bool has({ String action, String state });
		
		/**
		 * Add a valid link between two states.
		 * The state machine can then move between
		 * @param fromState State you want to move from.
		 * @param toState State you want to move to.
		 * @param action Action that when performed will move from the from state to the to state.
		 * @param handler Optional method that gets called when moving between these two states.
		 * @return true if link was added, false if it was not.
		 */
		bool action( String fromState, String toState, String action, [ Function handler = null ]);
		
		/**
		 * Adds a new state to the state machine.
		 * @param newState The new state to add.
		 * @return True is teh state was added, false if it was not.
		 */
		bool add( String newState );
		
		/**
		 * Move from the current state to another state.
		 * @param toState New state to try and move to.
		 * @return True if the state machine has moved to this new state, false if it was unable to do so.
		 */
		bool change( String toState );
		
		/**
		 * Change the current state by performing an action.
		 * @param action The action to perform.
		 * @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
		 */
		bool perform( String actionName );
		
		/**
		 * What are the valid actions you can perform from the current state?
		 * @return An array of actions.
		 */
		List<Action> actions();
		
		/**
		 * What are the valid states you can get to from the current state?
		 * @return An array of states.
		 */
		List<Meta> metas();
		
		/**
		 * Go back to the initial starting state
		 */
		void reset();
	}

## Usage

A simple usage example:
 ```dart
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
            () {
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
            () {
                print("> CURRENT on ACTION_LOADING_COMPLETE - state: " + states.current());
                scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + states.current()));
            }
    );

    states.action(
            STATE_LOADING,
            STATE_LOADING_FAILED,
            ACTION_LOADING_FAILED,
            () {
                print("> CURRENT on ACTION_LOADING_FAILED state: " + states.current());
                scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + states.current()));
            }
    );

    states.perform( ACTION_LOADING_START );
```
## Features and bugs

