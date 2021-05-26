## 1.1.0:
- Null-safety changes implemented
- Examples with null-safety
- General corrections and few logs

## 1.0.0:
- Release version
- Renaming - from -> at, run -> handler, StatesTransitionFunction -> StatesTransitionHandler. 
- Each transition now has list of handlers instead of one it had before, thus execute method run them all in a sequence. 
- New API method - on - allows adding or appending another handler later on after transitional already made, but only for existing transition.

## 1.0.0-beta:
- Rethinking API: when, run, lock/unlock (with key), dispose, get locked, get all
- Subscription to state transitions: subscribe/unsubscribe
- Examples updated to use "cascade notation" 
- Tests updated
- Beta mark telling that more test required

## 0.9.21:
- README update with gif for SPA with States example

## 0.9.2:
- StatesActionListener with StateAction as first parameter
- States constructor accept optional id, in case of null generate one based on static counter
- Optional parameter for method "change" - [performAction], default is true
- Test coverage for major API methods
- Examples updated

## 0.9.1:
- SPA with states example
- StateAction and StateMeta

## 0.9.0:
- API change: States -> States

## 0.1.9
- Internal files renamed no effect on functionality

## 0.1.0
- Initial version, created by Vladimir Minkin
