library states;

part 'states/meta.dart';
part 'states/action.dart';

typedef StatesActionListener = void Function( StateAction action );

class States extends IStates {
	static int _INDEX = 0;

	String id;

	/// Create a state machine and populate with states
	States({ this.id = null }) {
		++_INDEX;
		id = id ?? 'states_$_INDEX';
	}

	List<StateAction> _actions = new List<StateAction>();
	List<StateMeta> _metas = new List<StateMeta>();
	StateMeta _current;

	/// Does an action exist in the state machine?
	///
	/// @param action The action in question.
	/// @return True if the action exists, false if it does not.
	bool has({ String action, String state, bool conform = true }) {
		var result = true;
		if ( action != null ) {
			result = ( _findActionName( action ) != null );
		}
		if ( state != null ) {
			bool stateNameExists = _findStateName(state) != null;
			result = conform ? result && stateNameExists : result || stateNameExists;
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
	bool action( String fromState, String toState, String actionName,
			[ StatesActionListener handler ]) {
		StateMeta from;
		StateMeta to;

		/// can't have duplicate actions
		for ( StateAction action in _actions ) {
			if (action.from.name == fromState && action.name == actionName) {
				return false;
			}
		}

		from = _findStateName( fromState );
		if ( from == null ) {
			add( fromState );
			from = _findStateName( fromState );
		}

		to = _findStateName( toState );
		if ( to == null ) {
			add( toState );
			to = _findStateName( toState );
		}
		_actions.add( new StateAction( from, to, actionName, handler ));

		return true;
	}

	/// Adds a new state to the state machine.
	///
	/// @param newState The new state to add.
	/// @return True is teh state was added, false if it was not.
	bool add( String newState ) {
		/// can't have duplicate states
		if ( has( state: newState )) return false;
		_metas.add( new StateMeta( newState ));
		/// if no states exist set current state to first state
		if ( _metas.length == 1 ) _current = _metas[0];
		return true;
	}

	/// Move from the current state to another state.
	///
	/// @param toState New state to try and move to.
	/// @param performAction Should execute action function or not, default true.
	/// @return True if the state machine has moved to this new state, false if it was unable to do so.
	bool change( String toState, { bool performAction = true } ) {
		if ( !has( state: toState )) return false;
//		print('> States -> change: $current to $toState');
		for ( var action in _actions ) {
			if ( action.from == _current && action.to.name == toState ) {
				if ( performAction && action.action != null ) {
					action.action( action );
				}
				_current = action.to;
				return true;
			}
		}

		return false;
	}

	/// What is the current state?
	///
	/// @return The current state.
	String current() {
		return _current != null ? _current.name : null;
	}

	/// Change the current state by performing an action.
	///
	/// @param action The action to perform.
	/// @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
	bool perform( String actionName ) {
		for ( var action in _actions ) {
			if ( action.from == _current && actionName == action.name ) {
				if ( action.action != null ) {
//					print('> States : ${action.fromState.name} - $actionName');
					action.action( action );
				}
				_current = action.to;
				return true;
			}
		}
		return false;
	}

	/// Go back to the initial starting state
	void reset() {
		_current = _metas.isNotEmpty ? _metas[0] : null;
	}

	/// What are the valid actions you can perform from the current state?
	///
	/// @return An array of actions.
	List<StateAction> actions() {
		List<StateAction> actions = [];
		for ( var action in _actions ) {
			if ( action.from == _current ) {
				actions.add(action);
			}
		}
		return actions;
	}

	/// What are the valid states you can get to from the current state?
	///
	/// @return An array of states.
	List<StateMeta> metas() {
		List<StateMeta> states = [];
		for ( var action in _actions ) {
			if ( action.from == _current ) {
				states.add(action.to);
			}
		}
		return states;
	}

	StateMeta _findStateName(String stateName) {
		for ( var meta in _metas ) {
			if ( meta.name == stateName ) {
				return meta;
			}
		}
		return null;
	}

	StateAction _findActionName( String actionName ) {
		for ( var action in _actions ) {
			if ( action.name == actionName ) {
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
	bool change( String toState,  { bool performAction = true } );
	bool action( String fromState, String toState, String action,
			[ StatesActionListener handler ]);
	bool perform( String actionName );
	List<StateAction> actions();
	List<StateMeta> metas();
	void reset();
}
