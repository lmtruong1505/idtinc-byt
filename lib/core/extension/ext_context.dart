part of 'init_ext.dart';

extension extContext on BuildContext {
  EdgeInsets get padding => MediaQuery.of(
    this,
  ).padding.copyWith(bottom: Platform.isAndroid ? 20 : null);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  ColorScheme get color => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  pop({dynamic result}) {
    Navigator.pop(this, result);
  }

  back({dynamic result}) {
    Navigator.maybePop(this, result);
  }

  void popUntil(String route) async {
    Navigator.popUntil(this, ModalRoute.withName(route));
  }

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  Future pushName(
    String route, {
    dynamic arguments,
    bool isNewTask = false,
    bool login = false,
    String? routeLogin,
  }) async {
    if (login) {}
    if (isNewTask) {
      return await Navigator.of(
        this,
      ).pushNamedAndRemoveUntil(route, (route) => false, arguments: arguments);
    }
    return await Navigator.of(this).pushNamed(route, arguments: arguments);
  }

  Future push(
    Widget page, {
    bool isNewTask = false,
    bool login = false,
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
    Widget? screenLogin,
  }) async {
    final Widget child = login && screenLogin != null ? screenLogin : page;

    if (isNewTask) {
      return await Navigator.of(this).pushAndRemoveUntil(
        _router(
          child,
          duration: duration,
          pageRouteAnimation: pageRouteAnimation,
        ),
        (route) => false,
      );
    }
    return await Navigator.of(this).push(
      _router(
        child,
        duration: duration,
        pageRouteAnimation: pageRouteAnimation,
      ),
    );
  }

  Future bottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) async {
    return await showModalBottomSheet(
      context: this,
      builder: (context) => child,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      //shape: RoundedRectangleBorder(borderRadius: 20.radiusTop),
    );
  }

  Future dialog({required Widget child, bool isDismissble = true}) async {
    return await showDialog(
      context: this,
      barrierDismissible: isDismissble,
      builder: (context) => child,
    );
  }

  PageRoute _router(
    Widget child, {
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  }) {
    if (pageRouteAnimation != null) {
      if (pageRouteAnimation == PageRouteAnimation.Fade) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return RotationTransition(
              turns: ReverseAnimation(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return ScaleTransition(scale: anim, child: child);
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? 400.milliseconds,
        );
      }
    }
    return MaterialPageRoute(builder: (_) => child);
  }

  //login ? const ScreenLogin() : page
}

enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }
