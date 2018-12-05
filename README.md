# StateMachine for Dart v.01

A library for Dart developers.

	IStateMachine {
		
		/**
		 * What is the current state?
		 * @return The current state.
		 */
		String currentState();
		
		/**
		 * Does an action exist in the state machine?
		 * @param action The action in question.
		 * @return True if the action exists, false if it does not.
		 */
		bool actionExists( String checkAction );
		
		/**
		 * Add a valid link between two states.
		 * The state machine can then move between
		 * @param fromState State you want to move from.
		 * @param toState State you want to move to.
		 * @param action Action that when performed will move from the from state to the to state.
		 * @param handler Optional method that gets called when moving between these two states.
		 * @return true if link was added, false if it was not.
		 */
		bool addAction( String fromState, String toState, String action, [ Function handler = null ]);
		
		/**
		 * Adds a new state to the state machine.
		 * @param newState The new state to add.
		 * @return Ture is teh state was added, false if it was not.
		 */
		bool addState( String newState );
		
		/**
		 * Move from the current state to another state.
		 * @param toState New state to try and move to.
		 * @return True if the state machine has moved to this new state, false if it was unable to do so.
		 */
		bool changeState( String toState );
		
		/**
		 * Does a state exist?
		 * @param state The state in question.
		 * @return True if the state exists, false if it does not.
		 */
		bool stateExists( String checkState );
		
		/**
		 * Change the current state by performing an action.
		 * @param action The action to perform.
		 * @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
		 */
		bool performAction( String actionName );
		
		/**
		 * What are the valid actions you can perform from the current state?
		 * @return An array of actions.
		 */
		List<Action> validActions();
		
		/**
		 * What are the valid states you can get to from the current state?
		 * @return An array of states.
		 */
		List<State> validStates();
		
		/**
		 * Go back to the initial starting state
		 */
		void reset();
	}

## Usage

A simple usage example:

	import 'package:StateMachine/StateMachine.dart';

	main() {
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
			}
		);
	
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

## Features and bugs

