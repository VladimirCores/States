import 'dart:html';

import 'base/page.dart';

class Navigator {
  late DivElement _root;

  Navigator(DivElement root) {
    _root = root;
  }

  Page navigateFromTo(Page? from, Page to) {
    if (from != null) {
      from.dom.remove();
      from.destroy();
    }
    if (to.shouldRender()) to.render();
    _root.append(to.dom);
    return to;
  }
}
