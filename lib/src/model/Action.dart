part of state_machine;

//------------------------------------------------------------------------------
//
// Copyright (c) 2018 Vladimir Cores (Minkin) @ LOGICO Technologies (https://logico.tech)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

class Action
{
	/**
	 * Creates a new action. The action method is optional.
	 * @param fromState State to move form.
	 * @param toState State to move to.
	 * @param name Action's name.
	 * @param action Method to call on performing action.
	 */
	Action( State fromState, State toState, String name, [ Function action = null ]) {
		_fromState = fromState;
		_toState = toState;
		_name = name;
		_action = action;
	}

	State _fromState;
	State _toState;
	String _name;
	Function _action;

	/**
	 * @return The method to call on preforming the action.
	 */
	Function get action {
		return _action;
	}

	/**
	 * @return The state to move from.
	 */
	State get fromState {
		return _fromState;
	}

	/**
	 * @return The action's name.
	 */
	String get name {
		return _name;
	}

	/**
	 * @return  The state to move to.
	 */
	State get toState {
		return _toState;
	}
}