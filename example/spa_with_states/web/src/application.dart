import 'components/navigator.dart';
import 'components/pages/gallery.page.dart';
import 'components/pages/index.page.dart';
import 'components/pages/login.page.dart';
import 'components/base/page.dart';
import 'components/pages/signout.page.dart';

class Application {

  Page _currentPage;
  Navigator _navigator;

  Application(Navigator navigator) {
    _navigator = navigator;
  }

  void goToLoginPage() {
    _navigateTo(LoginPage());
  }

  void goToIndexPage() {
    _navigateTo(IndexPage());
  }

  void goToGalleryPage() {
    _navigateTo(GalleryPage());
  }

  void goToSignoutPage() {
    _navigateTo(SignoutPage());
  }

  void _navigateTo(Page page) {
    _currentPage = _navigator.navigateFromTo(_currentPage, page);
  }
}
