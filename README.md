# States - Finite State Machine for Dart
## API:
```dart
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
```

## Usage

### A simple usage example:
 ```dart
	States states = new States();

    states.add( STATE_INITIAL );

    states.add( STATE_LOADING );
    states.add( STATE_LOADING_COMPLETE );
    states.add( STATE_LOADING_FAILED );

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
```
### SPA with States
Please take a look how this library can help to create SPA with simple dart:html
![SPA with States](assets/spa_with_states.gif)


