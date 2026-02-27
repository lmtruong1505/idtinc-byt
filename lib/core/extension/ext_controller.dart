part of 'init_ext.dart';

extension ExtScroll on ScrollController {
  onMore(Function() call) {
    addListener(() {
      if (position.pixels == position.maxScrollExtent) {
        call();
      }
    });
  }
}
