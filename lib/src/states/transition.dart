part of states;

///------------------------------------------------------------------------------
///
/// Copyright (c) 2019 Vladimir Cores (Minkin)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
///------------------------------------------------------------------------------

typedef StatesTransitionHandler = void Function(StatesTransition transition);

class StatesTransition {
  /// Creates a new action. The action method is optional.
  ///
  /// @param fromState State to move form.
  /// @param toState State to move to.
  /// @param name Action's name.
  /// @param action Method to call on performing action.
  StatesTransition(StatesMeta? from, StatesMeta? to, String action, [StatesTransitionHandler? handler]) {
    _from = from;
    _to = to;
    _action = action;
    append(handler);
  }

  late final StatesMeta? _from;
  late final StatesMeta? _to;
  late String _action;
  final List<StatesTransitionHandler> _handlers = [];

  void dispose() {
    _handlers.clear();
  }

  void append(StatesTransitionHandler? func) {
    if (func != null) _handlers.add(func);
  }

  /// @return The method to call on preforming the action.
  List<StatesTransitionHandler> get handlers => _handlers;

  /// @return The state to move from.
  StatesMeta? get at => _from;

  /// @return The action's name.
  String get action => _action;

  /// @return  The state to move to.
  StatesMeta? get to => _to;

  String toString() {
    return " [${_from?.name}]"
        " -> [${_to?.name}]"
        " on: [${_action}]";
  }
}
