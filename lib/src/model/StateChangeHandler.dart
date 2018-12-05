part of StateMachine;

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

/**
 * Handler for a state change in a state machine.
 */
class StateChangeHandler
{

	/**
	 * Creates a new state change handler.
	 * @param fromState State for move form.
	 * @param toState State to move to.
	 * @param handler Method to call on changing state.
	 */
	StateChangeHandler(String fromState, String toState, Function handler)
	{
		_fromState = fromState;
		_toState = toState;
		_handler = handler;
	}

	String _toState;
	String _fromState;
	Function _handler;

	/**
	 * @return  State to move to.
	 */
	String get toState {
		return _toState;
	}

	/**
	 * @return State to move form.
	 */
	String get fromState {
		return _fromState;
	}

	/**
	 * @return Method to call on changing state.
	 */
	Function get handler {
		return _handler;
	}
}