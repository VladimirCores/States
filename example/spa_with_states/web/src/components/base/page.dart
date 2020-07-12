import 'dart:html';

abstract class Page {

  static final EVENT_ACTION = "page_event_action";

  DivElement dom;

  Page() {
    dom = new DivElement();
    dom.className = "page ";
  }

  void dispatchAction(String action) {
    dom.dispatchEvent(new CustomEvent(EVENT_ACTION, detail:action));
  }

  bool shouldRender() { return true; }

  void render() { }
  void destroy() {
    dom = null;
  }
}