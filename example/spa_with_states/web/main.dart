import 'dart:html';

import 'package:states/states.dart';

import 'src/application.dart';
import 'src/const/Action.dart';
import 'src/const/State.dart';
import 'src/components/base/page.dart';
import 'src/components/navigator.dart';

void main() {
  DivElement root = querySelector('#root') as DivElement;
  Navigator navigator = Navigator(root);
  Application application = Application(navigator);

  States pagesStates = States();

  print('> Step 1 -> Register states: ${pagesStates.id}');
  pagesStates.add(State.INITIAL);
  pagesStates.add(State.PAGE_INDEX);
  pagesStates.add(State.PAGE_LOGIN);
  pagesStates.add(State.PAGE_GALLERY);
  pagesStates.add(State.PAGE_SIGNOUT);

  print('> Step 2 -> Register transitions');
  pagesStates
    ..when(
      at: State.INITIAL,
      to: State.PAGE_INDEX,
      on: Action.INITIALIZE,
      handler: (StatesTransition transition) => application.goToIndexPage())
    ..when(
      at: State.PAGE_INDEX,
      to: State.PAGE_LOGIN,
      on: Action.INDEX_PAGE_BUTTON_LOGIN_CLICKED,
      handler: (StatesTransition transition) => application.goToLoginPage())
    ..when(
      at: State.PAGE_LOGIN,
      to: State.PAGE_INDEX,
      on: Action.LOGIN_PAGE_BUTTON_INDEX_CLICKED,
      handler: (StatesTransition transition) => application.goToIndexPage())
    ..when(
      at: State.PAGE_LOGIN,
      to: State.PAGE_GALLERY,
      on: Action.LOGIN_PAGE_BUTTON_GALLERY_CLICKED,
      handler: (StatesTransition transition) => application.goToGalleryPage())
    ..when(
      at: State.PAGE_GALLERY,
      to: State.PAGE_INDEX,
      on: Action.GALLERY_PAGE_BUTTON_INDEX_CLICKED,
      handler: (StatesTransition transition) => application.goToIndexPage())
    ..when(
      at: State.PAGE_GALLERY,
      to: State.PAGE_SIGNOUT,
      on: Action.GALLERY_PAGE_BUTTON_EXIT_CLICKED,
      handler: (StatesTransition transition) => application.goToSignoutPage())
    ..when(
      at: State.PAGE_SIGNOUT,
      to: State.PAGE_INDEX,
      on: Action.SIGNOUT_PAGE_TIMER_EXPIRED,
      handler: (StatesTransition transition) => application.goToIndexPage());

  print('> Step 3 -> Add Event Listener');
  root.addEventListener(Page.EVENT_ACTION, (e) => pagesStates.execute((e as CustomEvent).detail));
  print('> Step 4 -> execute: Action.INITIALIZE');
  pagesStates.execute(Action.INITIALIZE);
}
