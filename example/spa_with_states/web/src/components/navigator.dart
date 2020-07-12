import 'dart:html';

import 'page.dart';

class Navigator {

  DivElement _root;

  Navigator(DivElement root) { _root = root; }

  Page navigateFromTo(Page from, Page to) {
    if (from != null) {
      from.dom.remove();
      from.destroy();
    }
    if (to.shouldRender()) to.render();
    _root.append(to.dom);
    return to;
  }
}