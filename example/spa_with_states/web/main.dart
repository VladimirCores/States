import 'dart:html';

import 'package:states/states.dart';

import 'src/application.dart';
import 'src/const/Action.dart';
import 'src/const/State.dart';
import 'src/components/base/page.dart';
import 'src/components/navigator.dart';

void main() {

  DivElement root = querySelector('#root');
  Navigator navigator = Navigator( root );
  Application application = Application( navigator );

  States pagesStates = States();
  pagesStates.add( State.INITIAL );

  pagesStates.add( State.PAGE_INDEX );
  pagesStates.add( State.PAGE_LOGIN );
  pagesStates.add( State.PAGE_GALLERY );
  pagesStates.add( State.PAGE_SIGNOUT );

  pagesStates.when( from: State.INITIAL, to: State.PAGE_INDEX,
    on: Action.INITIALIZE,
    run: (StatesTransition transition) => application.goToIndexPage()
  );

  pagesStates
    ..when( from: State.PAGE_INDEX, to: State.PAGE_LOGIN,
      on: Action.INDEX_PAGE_BUTTON_LOGIN_CLICKED,
      run: (StatesTransition transition) => application.goToLoginPage()
    )
    ..when( from: State.PAGE_LOGIN, to: State.PAGE_INDEX,
      on: Action.LOGIN_PAGE_BUTTON_INDEX_CLICKED,
      run: (StatesTransition transition) => application.goToIndexPage()
    )
    ..when( from: State.PAGE_LOGIN, to: State.PAGE_GALLERY,
      on: Action.LOGIN_PAGE_BUTTON_GALLERY_CLICKED,
      run: (StatesTransition transition) => application.goToGalleryPage()
    )
    ..when( from: State.PAGE_GALLERY, to: State.PAGE_INDEX,
      on: Action.GALLERY_PAGE_BUTTON_INDEX_CLICKED,
      run: (StatesTransition transition) => application.goToIndexPage()
    )
    ..when( from: State.PAGE_GALLERY, to: State.PAGE_SIGNOUT,
      on: Action.GALLERY_PAGE_BUTTON_EXIT_CLICKED,
      run: (StatesTransition transition) => application.goToSignoutPage()
    )
    ..when( from: State.PAGE_SIGNOUT, to: State.PAGE_INDEX,
      on: Action.SIGNOUT_PAGE_TIMER_EXPIRED,
      run: (StatesTransition transition) => application.goToIndexPage()
    );

  root.addEventListener( Page.EVENT_ACTION, (e) => pagesStates.run((e as CustomEvent).detail) );

  pagesStates.run( Action.INITIALIZE );
}


