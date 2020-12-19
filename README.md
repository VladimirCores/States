# States - Beautiful Finite State Machine (FMS) for Dart
## API:
```dart
abstract class IStates {
  String get current;
  bool get locked;
  List<StatesTransition> get all;
  
  List<StatesTransition> actions({String from});
  List<StatesMeta> metas({String from});
  
  StatesMeta add( String state );
  StatesTransition when({
    String at,
    String to,
    String on,
    StatesTransitionFunction handler
  });
  
  String subscribe(StatesTransitionFunction listener);
  bool unsubscribe(String subscriptionKey);
  
  bool change({ String to, bool run = true });
  bool has({
    String action,
    String state,
    bool conform = true
  });
  StatesTransition get( String action );
  bool execute( String action );
  bool on(String action, StatesTransitionHandler listener);
  
  void reset();
  void dispose();
  
  void lock({@required String key});
  void unlock({@required String key});
}
```

## Usage

### A simple usage example:
 ```dart
  States states = new States();

  states.add( STATE_INITIAL );

  states.add( STATE_LOADING );
  states.add( STATE_LOADING_COMPLETE );
  states.add( STATE_LOADING_FAILED );

  states.when(
    at: STATE_INITIAL,
    to: STATE_LOADING,
    on: ACTION_LOADING_START,
    execute: (StatesTransition action) {
      print("> CURRENT on ACTION_LOADING_START state: " + states.current);
      scheduleMicrotask(() {
        print("> \t END OF microtask queue -> state: " + states.current);
        var nextBool = Random.secure().nextBool();
        print("> \t\t next bool: " + nextBool.toString());
        states.run( nextBool ? ACTION_LOADING_COMPLETE : ACTION_LOADING_FAILED );
        });
      });
  
  states.when(
    at: STATE_LOADING,
    to: STATE_LOADING_COMPLETE,
    on: ACTION_LOADING_COMPLETE,
    execute: (StatesTransition action) {
      print("> CURRENT on ACTION_LOADING_COMPLETE - state: " + states.current);
      scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + states.current));
    }
  );
  
  states.when(
    at: STATE_LOADING,
    to: STATE_LOADING_FAILED,
    on: ACTION_LOADING_FAILED,
    execute: (StatesTransition action) {
      print("> CURRENT on ACTION_LOADING_FAILED state: " + states.current);
      scheduleMicrotask(() => print("> \t END OF microtask queue -> state: " + states.current));
    }
  );
  
  states.run( ACTION_LOADING_START );
```
### SPA with States
Please take a look how this library can help to create SPA with simple dart:html
See folder example/spa_with_states
![SPA with States](assets/spa_with_states.gif)


