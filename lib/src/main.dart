library states;

part 'states/meta.dart';
part 'states/transition.dart';

class States extends IStates {
  static const String DISPOSE = 'states_reserved_action_dispose';
  static const String EXCEPTION__LOCK_KEY = 'LOCK KEY MUST BE DEFINED';

  static int _INDEX = 0;

  String? id;

  String _lockKey = '';
  bool get locked => _lockKey.length > 0;
  List<StatesTransition> get all => _transitions.map((e) => e) as List<StatesTransition>;

  /// What is the current state?
  ///
  /// @return The current state.
  String? get current => _currentStateMeta?.name;
  StatesMeta? _currentStateMeta;

  /// Create a state machine and populate with states
  States({this.id = null}) {
    ++_INDEX;
    id = id ?? 'states_$_INDEX';
  }

  final List<StatesTransition> _transitions = [];
  final List<StatesMeta> _metas = [];
  final Map<String, StatesTransitionHandler> _subscribers = Map<String, StatesTransitionHandler>();

  void _changeCurrentStateWithTransition(StatesTransition transition, {bool run = true}) {
    if (run && transition.handlers.isNotEmpty) {
      transition.handlers.forEach((handler) => handler(transition));
    }
    _currentStateMeta = transition.to;
    // print('<<< _currentStateMeta: ${_currentStateMeta}');
    _subscribers.values.forEach((s) => s(transition));
  }

  /// Does an action exist in the state machine?
  ///
  /// @param action The action in question.
  /// @return True if the action exists, false if it does not.
  bool has({String? action, String? state, bool conform = true}) {
    var result = false;
    bool stateActionExists = false;
    bool stateNameExists = false;

    if (action != null) {
      stateActionExists = _findStateTransitionByAction(action) != null;
    } else
      stateActionExists = state != null;

    if (state != null) {
      stateNameExists = _findStateMetaByName(state) != null;
    } else
      stateNameExists = stateActionExists;

    result = conform
        ? (stateActionExists && stateNameExists)
        : (stateActionExists || stateNameExists);

    return result;
  }

  /// Add a valid link between two states. The state machine can then move between
  ///
  /// @param fromState State you want to move from.
  /// @param toState State you want to move to.
  /// @param action Action that when performed will move from the from state to the to state.
  /// @param handler Optional method that gets called when moving between these two states.
  /// @return true if link was added, false if it was not.
  StatesTransition? when({
    required String at,
    required String to,
    required String on,
    StatesTransitionHandler? handler
  }) {
    // print('< States -> when: ${at} | ${to} | ${on}');
    if (locked) return null;

    StatesMeta? metaFrom;
    StatesMeta? metaTo;

    /// can't have duplicate actions
    for (StatesTransition transitions in _transitions) {
      final actionAlreadyRegistered =
        transitions.at?.name == at &&
        transitions.to?.name == to &&
        transitions.handlers.contains(handler) &&
        transitions.action == on;

      if (actionAlreadyRegistered) return null;
    }

    metaFrom = _findStateMetaByName(at);
    if (metaFrom == null) {
      metaFrom = add(at);
    }

    metaTo = _findStateMetaByName(to);
    if (metaTo == null) {
      metaTo = add(to);
    }

    final st = StatesTransition(
        metaFrom!,
        metaTo!,
        on,
        handler
    );
    _transitions.add(st);

    return st;
  }

  String? subscribe(StatesTransitionHandler func, {bool single = false}) {
    if (single && _subscribers.values.any((s) => s == func)) return null;
    final subscriptionKey = '_ssk${_subscribers.length}${DateTime.now().toString()}';
    _subscribers[subscriptionKey] = func;
    return subscriptionKey;
  }

  bool unsubscribe(String subscriptionKey) {
    final result = _subscribers.keys.contains(subscriptionKey);
    if (result) _subscribers.remove(subscriptionKey);
    return result;
  }

  /// Adds a new state to the state machine.
  ///
  /// @param newState The new state to add.
  /// @return True is teh state was added, false if it was not.
  StatesMeta? add(String state) {
    // print('< States -> add: ${state}');
    if (locked) return null;

    /// can't have duplicate states
    if (has(state: state)) return null;
    final stateMeta = StatesMeta(state);
    _metas.add(stateMeta);

    /// if no states exist set current state to first state
    if (_metas.length == 1) {
      _currentStateMeta = stateMeta;
      // print('<< _currentStateMeta: ${stateMeta.name}');
    }
    return stateMeta;
  }

  /// Move from the current state to another state.
  ///
  /// @param toState New state to try and move to.
  /// @param performAction Should execute action function or not, default true.
  /// @return True if the state machine has moved to this new state, false if it was unable to do so.
  bool change({required String toStateName, bool run = true}) {
    if (!has(state: toStateName)) return false;
    for (var transition in _transitions) {
      if (transition.at == _currentStateMeta && transition.to != null && transition.to!.isEqual(toStateName)) {
        _changeCurrentStateWithTransition(transition, run: run);
        return true;
      }
    }

    return false;
  }

  /// Change the current state by performing an action.
  ///
  /// @param action The action to perform.
  /// @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
  bool execute(String action) {
    // print('< States -> execute: ${action}');
    for (var transition in _transitions) {
      if (transition.at == _currentStateMeta && transition.action == action) {
        // print('<< transition: ${transition}');
        _changeCurrentStateWithTransition(transition);
        return true;
      }
    }
    return false;
  }

  /// Adds handler to the specific action
  ///
  /// @param action The action to which assign handler.
  /// @param handler [StatesTransitionHandler] which will executed on specified action
  /// @return True if the action is transition with specified action registered in the states.
  bool on(String action, StatesTransitionHandler handler) {
    for (var transition in _transitions) {
      if (transition.action == action) {
        transition.append(handler);
        return true;
      }
    }
    return false;
  }

  StatesTransition? get(String action) {
    for (var stateAction in _transitions) {
      if (action == stateAction.action) {
        return stateAction;
      }
    }
    return null;
  }

  void lock({required String key}) {
    if (key == null || key.length == 0) throw Exception(EXCEPTION__LOCK_KEY);
    _lockKey = key;
  }

  void unlock({required String key}) {
    if (_lockKey == key) _lockKey = '';
  }

  /// Go back to the initial starting state
  void reset() {
    _currentStateMeta = _metas.isNotEmpty ? _metas[0] : null;
  }

  void dispose() {
    _currentStateMeta = null;
    for (var action in _transitions) {
      action.dispose();
    }
    final disposeTransition = StatesTransition(_currentStateMeta!, null, DISPOSE);
    for (var key in _subscribers.keys) {
      var sub = _subscribers[key];
      if (sub != null) sub(disposeTransition);
    }
    _subscribers.clear();
    _transitions.clear();
    _metas.clear();
    _INDEX = 0;
  }

  /// What are the valid actions you can perform from the current state?
  ///
  /// @return An array of actions.
  List<StatesTransition> actions({String? from}) {
    StatesMeta? base = from == null ? _currentStateMeta : _findStateMetaByName(from);
    List<StatesTransition> actions = [];
    for (var action in _transitions) {
      if (action.at == base) {
        actions.add(action);
      }
    }
    return actions;
  }

  /// What are the valid states you can get to from the current state?
  ///
  /// @return An array of states.
  List<StatesMeta> metas({String? from}) {
    StatesMeta? base = from == null ? _currentStateMeta : _findStateMetaByName(from);
    List<StatesMeta> metas = [];
    for (var action in _transitions) {
      if (action.at == base && action.to != null) {
        metas.add(action.to!);
      }
    }
    return metas;
  }

  StatesMeta? _findStateMetaByName(String state) {
    for (var stateMeta in _metas) {
      if (stateMeta.name == state) {
        return stateMeta;
      }
    }
    return null;
  }

  StatesTransition? _findStateTransitionByAction(String action) {
    for (var transition in _transitions) {
      if (transition.action == action) {
        return transition;
      }
    }
    return null;
  }
}

abstract class IStates {
  String? get current;
  bool get locked;
  List<StatesTransition> get all;

  List<StatesTransition> actions({String from});
  List<StatesMeta> metas({String from});

  StatesMeta? add(String state);
  StatesTransition? when({
    required String at, required String to, required String on,
    StatesTransitionHandler? handler
  });

  String? subscribe(StatesTransitionHandler listener);
  bool unsubscribe(String subscriptionKey);

  bool change({required String toStateName, bool run = true});
  bool? has({String action, String state, bool conform = true});
  StatesTransition? get(String action);
  bool execute(String action);
  bool on(String action, StatesTransitionHandler listener);

  void reset();
  void dispose();

  void lock({required String key});
  void unlock({required String key});
}
