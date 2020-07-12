import 'dart:html';

import '../../const/Action.dart';
import '../base/page.dart';

class GalleryPage extends Page {
  ButtonElement _btnIndex;
  ButtonElement _btnExit;

  GalleryPage():super() {
    _btnIndex = ButtonElement();
    _btnExit = ButtonElement();
    dom.style.backgroundColor = "antiquewhite";
  }

  void render() {
    _btnIndex.addEventListener("click", _handleClickEvent);
    _btnIndex.text = "INDEX";

    _btnExit.addEventListener("click", _handleClickEvent);
    _btnExit.text = "EXIT";

    dom.append(_btnIndex);
    dom.append(_btnExit);
  }

  void destroy() {
    _btnIndex.removeEventListener("click", _handleClickEvent);
    _btnIndex = null;

    _btnExit.removeEventListener("click", _handleClickEvent);
    _btnExit = null;

    super.destroy();
  }

  void _handleClickEvent(event) {
    var ct = event.currentTarget;
    if (ct == _btnIndex) {
      dispatchAction( Action.GALLERY_PAGE_BUTTON_INDEX_CLICKED );
    }
    else if (ct == _btnExit) {
      dispatchAction( Action.GALLERY_PAGE_BUTTON_EXIT_CLICKED );
    }
  }
}
