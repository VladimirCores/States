# EXAMPLE:

### 1. Simple Loading FMS
Output:
```dart
> BEFORE LOADING START -> state: state_initial
> RUN -> ACTION_LOADING_START
> CURRENT -> ACTION_LOADING_START 
		state: state_initial 
		transition:  [state_initial] -> [state_loading] on: [action_start_loading]
> 	 END OF microtask queue -> state: state_loading next action: action_loading_complete
> CURRENT -> ACTION_LOADING_COMPLETE 
		state: state_loading 
		transition:  [state_loading] -> [state_loading_complete] on: [action_loading_complete]
> 	 END OF microtask queue -> state: state_loading_complete
```
### 2. SPA with States
Please take a look how this library can help to create SPA with simple dart:html
See folder example/spa_with_states
![SPA with States](../assets/spa_with_states.gif)


