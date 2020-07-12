library machine;

part 'model/meta.dart';
part 'model/action.dart';

class States extends IStates {
	/// Create a state machine and populate with states
	States();

	List<Action> _actions = new List<Action>();
	List<Meta> _metas = new List<Meta>();
	Meta _currentStateMeta;

	/// Does an action exist in the state machine?
	///
	/// @param action The action in question.
	/// @return True if the action exists, false if it does not.
	bool has({ String action, String state, bool conform = true }) {
		var result = false;
		if (action != null) {
			result = (_findState(action) != null);
		}
		if (state != null) {
			result = conform ? result && _exists(state) : result || _exists(state);
		}
		return result;
	}


	/// Add a valid link between two states. The state machine can then move between
	///
	/// @param fromState State you want to move from.
	/// @param toState State you want to move to.
	/// @param action Action that when performed will move from the from state to the to state.
	/// @param handler Optional method that gets called when moving between these two states.
	/// @return true if link was added, false if it was not.
	bool action( String fromState, String toState, String actionName, [ Function handler ]) {
		Meta from;
		Meta to;

		/// can't have duplicate actions
		for ( Action action in _actions ) {
			if ( action.fromState.name == fromState && action.name == actionName ) {
				return false;
			}
		}

		from = _findState( fromState );
		if ( from == null ) {
			add( fromState );
			from = _findState( fromState );
		}

		to = _findState( toState );
		if ( to == null ) {
			add( toState );
			to = _findState( toState );
		}
		_actions.add( new Action( from, to, actionName, handler ));

		return true;
	}

	/// Adds a new state to the state machine.
	///
	/// @param newState The new state to add.
	/// @return True is teh state was added, false if it was not.
	bool add( String newState ) {
		/// can't have duplicate states
		if ( has( state: newState )) {
			return false;
		}

		_metas.add( new Meta( newState ));

		/// if no states exist set current state to first state
		if ( _metas.length == 1 ) {
			_currentStateMeta = _metas[0];
		}

		return true;
	}

	/// Move from the current state to another state.
	///
	/// @param toState New state to try and move to.
	/// @return True if the state machine has moved to this new state, false if it was unable to do so.
	bool change( String toState ) {
		if ( !has( state: toState )) return false;

		for ( var action in _actions ) {
			if ( action.fromState == _currentStateMeta && action.toState.name == toState ) {
				if ( action.action != null) {
					action.action();
				}
				_currentStateMeta = action.toState;
				return true;
			}
		}
		return false;
	}

	/// What is the current state?
	///
	/// @return The current state.
	String current() { return _currentStateMeta != null ? _currentStateMeta.name : null; }

	/// Change the current state by performing an action.
	///
	/// @param action The action to perform.
	/// @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
	bool perform( String actionName ) {
		for ( Action action in _actions ) {
			if ( action.fromState == _currentStateMeta && actionName == action.name ) {
				if ( action.action != null) {
//					print('> Machine : ${action.fromState.name} - $actionName');
					action.action();
				}
				_currentStateMeta = action.toState;
				return true;
			}
		}
		return false;
	}

	/// Go back to the initial starting state
	void reset() { _currentStateMeta = _metas.isNotEmpty ? _metas[0] : null; }

	/// Does a state exist?
	///
	/// @param state The state in question.
	/// @return True if the state exists, false if it does not.
	bool _exists( String checkState ) {
		for ( Meta stateMeta in _metas ) {
			if ( checkState == stateMeta.name ) {
				return true;
			}
		}
		return false;
	}

	/// What are the valid actions you can perform from the current state?
	///
	/// @return An array of actions.
	List<Action> actions() {
		List<Action> actions = [];
		for ( Action action in _actions ) {
			if ( action.fromState == _currentStateMeta ) {
				actions.add(action);
			}
		}
		return actions;
	}

	/// What are the valid states you can get to from the current state?
	///
	/// @return An array of states.
	List<Meta> metas() {
		List<Meta> states = [];
		for ( Action action in _actions ) {
			if ( action.fromState == _currentStateMeta ) {
				states.add(action.toState);
			}
		}
		return states;
	}

	Meta _findState( String exists ) {
		for ( var state in _metas ) {
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

abstract class IStates {
	String current();
	bool has({ String action, String state, bool conform = true });
	bool add( String newState );
	bool change( String toState );
	bool action( String fromState, String toState, String action, [ Function handler ]);
	bool perform( String actionName );
	List<Action> actions();
	List<Meta> metas();
	void reset();
}
