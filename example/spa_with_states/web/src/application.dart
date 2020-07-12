import 'components/navigator.dart';
import 'components/pages/gallery.page.dart';
import 'components/pages/index.page.dart';
import 'components/pages/login.page.dart';
import 'components/page.dart';
import 'components/pages/signout.page.dart';

class Application {

  Page _currentPage;
  Navigator _navigator;

  Application(Navigator navigator) {
    _navigator = navigator;
  }

  void goToLoginPage() {
    _navigateTo(new LoginPage());
  }

  void goToIndexPage() {
    _navigateTo(new IndexPage());
  }

  void goToGalleryPage() {
    _navigateTo(new GalleryPage());
  }

  void goToSignoutPage() {
    _navigateTo(new SignoutPage());
  }

  void _navigateTo(Page page) {
    _currentPage = _navigator.navigateFromTo(_currentPage, page);
  }
}