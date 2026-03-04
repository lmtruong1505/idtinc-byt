import 'package:flutter/material.dart';
import 'package:tasa/core/widgets/base/base_loading.dart';

/// A global loading overlay utility.
///
/// Usage in any cubit/screen action:
/// ```dart
/// BaseLoadingOverlay.show(context);
/// await someAsyncAction();
/// BaseLoadingOverlay.hide();
/// ```
///
/// Or use the convenience wrapper:
/// ```dart
/// await BaseLoadingOverlay.run(context, () async {
///   await someAsyncAction();
/// });
/// ```
class BaseLoadingOverlay {
  static OverlayEntry? _overlayEntry;

  /// Show the loading overlay on top of the current screen.
  static void show(BuildContext context) {
    hide(); // Dismiss any existing overlay first
    _overlayEntry = OverlayEntry(builder: (_) => _LoadingOverlayWidget());
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide the currently shown loading overlay.
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Convenience method: show loading, run [action], then hide loading.
  /// Guarantees loading is dismissed even if [action] throws.
  static Future<T> run<T>(
    BuildContext context,
    Future<T> Function() action,
  ) async {
    show(context);
    try {
      return await action();
    } finally {
      hide();
    }
  }
}

class _LoadingOverlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      child: const BaseLoading(color: Colors.white, size: 48),
    );
  }
}
