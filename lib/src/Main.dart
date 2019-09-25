library dart_machine;

part 'model/State.dart';
part 'model/Action.dart';

class DartMachine extends IDartMachine {
	/// Create a state machine and populate with states
	DartMachine();

	List<Action> _actions = new List<Action>();
	List<State> _states = new List<State>();
	State _currentState;

	/// Does an action exist in the state machine?
	///
	/// @param action The action in question.
	/// @return True if the action exists, false if it does not.
	bool actionExists( String checkAction ) {
		return ( _findState( checkAction ) != null );
	}


	/// Add a valid link between two states. The state machine can then move between
	///
	/// @param fromState State you want to move from.
	/// @param toState State you want to move to.
	/// @param action Action that when performed will move from the from state to the to state.
	/// @param handler Optional method that gets called when moving between these two states.
	/// @return true if link was added, false if it was not.
	bool addAction( String fromState, String toState, String action, [ Function handler ]) {
		State from;
		State to;

		/// can't have duplicate actions
		for ( Action check in _actions ) {
			if ( check.fromState.name == fromState && check.name == action ) {
				return false;
			}
		}

		from = _findState( fromState );
		if ( from == null ) {
			addState( fromState );
			from = _findState( fromState );
		}

		to = _findState( toState );
		if ( to == null ) {
			addState( toState );
			to = _findState( toState );
		}
		_actions.add( new Action( from, to, action, handler ));

		return true;
	}

	/// Adds a new state to the state machine.
	///
	/// @param newState The new state to add.
	/// @return True is teh state was added, false if it was not.
	bool addState( String newState ) {
		/// can't have duplicate states
		if ( stateExists( newState )) {
			return false;
		}

		_states.add( new State( newState ));

		/// if no states exist set current state to first state
		if ( _states.length == 1 ) {
			_currentState = _states[0];
		}

		return true;
	}

	/// Move from the current state to another state.
	///
	/// @param toState New state to try and move to.
	/// @return True if the state machine has moved to this new state, false if it was unable to do so.
	bool changeState( String toState ) {
		if ( !stateExists( toState )) return false;

		for ( var action in _actions ) {
			if ( action.fromState == _currentState && action.toState.name == toState ) {
				if ( action.action != null) {
					action.action();
				}
				_currentState = action.toState;
				return true;
			}
		}
		return false;
	}

	/// What is the current state?
	///
	/// @return The current state.
	String currentState() { return _currentState != null ? _currentState.name : null; }

	/// Change the current state by performing an action.
	///
	/// @param action The action to perform.
	/// @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
	bool performAction( String actionName ) {
		for ( Action action in _actions ) {
			if ( action.fromState == _currentState && actionName == action.name ) {
				if ( action.action != null) {
					action.action();
				}
				_currentState = action.toState;
				return true;
			}
		}
		return false;
	}

	/// Go back to the initial starting state
	void reset() { _currentState = _states.isNotEmpty ? _states[0] : null; }

	/// Does a state exist?
	///
	/// @param state The state in question.
	/// @return True if the state exists, false if it does not.
	bool stateExists( String checkState ) {
		for ( State state in _states ) {
			if ( checkState == state.name ) {
				return true;
			}
		}
		return false;
	}

	/// What are the valid actions you can perform from the current state?
	///
	/// @return An array of actions.
	List<Action> validActions() {
		List<Action> actions = [];
		for ( Action action in _actions ) {
			if ( action.fromState == _currentState ) {
				actions.add(action);
			}
		}
		return actions;
	}

	/// What are the valid states you can get to from the current state?
	///
	/// @return An array of states.
	List<State> validStates() {
		List<State> states = [];
		for ( Action action in _actions ) {
			if ( action.fromState == _currentState ) {
				states.add(action.toState);
			}
		}
		return states;
	}

	State _findState( String exists ) {
		for ( var state in _states ) {
			if ( state.name == exists ) {
				return state;
			}
		}
		return null;
	}

	Action _findAction( String exists ) {
		for ( var action in _actions ) {
			if ( action.name == exists ) {
				return action;
			}
		}
		return null;
	}
}

abstract class IDartMachine {
	String currentState();
	bool actionExists( String checkAction );
	bool addAction( String fromState, String toState, String action, [ Function handler ]);
	bool addState( String newState );
	bool changeState( String toState );
	bool stateExists( String checkState );
	bool performAction( String actionName );
	List<Action> validActions();
	List<State> validStates();
	void reset();
}
