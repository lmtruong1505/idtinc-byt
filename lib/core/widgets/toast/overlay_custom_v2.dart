import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';

typedef ItemOverlayBuilder<ItemType> =
    Widget Function(BuildContext context, ItemType item, int index);
typedef LoadDataOverlay<ItemType> =
    Future<List<ItemType>> Function(bool isMore);

class OverlayInputV2<T> extends StatefulWidget {
  final Function(T)? onChanged;
  final ItemOverlayBuilder<T> itemBuilder;
  final Widget? separator;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final double elevation;
  final Color backgroundColor;
  final double borderRadius;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final String? hintText;
  final String? label;
  final bool isRequired;
  final double itemHeight;
  final LoadDataOverlay<T>? lazyLoad;
  final Widget? header;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  const OverlayInputV2({
    super.key,
    required this.itemBuilder,
    this.separator,
    this.onChanged,
    this.padding,
    this.contentPadding,
    this.backgroundColor = Colors.white,
    this.borderRadius = 5,
    this.elevation = 5,
    this.focusedBorderColor = AppColors.red_1,
    this.enabledBorderColor = AppColors.grey79,
    this.hintText,
    this.label,
    this.isRequired = false,
    this.itemHeight = 60,
    this.lazyLoad,
    this.header,
    this.suffix,
    this.prefix,
    this.controller,
    this.autoFocus = false,
    this.focusNode,
    this.hintStyle,
    this.textStyle,
  });

  @override
  State<OverlayInputV2<T>> createState() => _OverlayInputV2State<T>();
}

class _OverlayInputV2State<T> extends State<OverlayInputV2<T>> {
  OverlayEntry? overlayEntry;
  final _layerLink = LayerLink();
  late TextEditingController? controler;
  final _scroll = ScrollController();
  late final _focusNode;
  final StreamController<OverlayItemsValue<T>> _streamController =
      StreamController.broadcast();
  final value = OverlayItemsValue<T>(items: []);
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    } else {
      _focusNode = widget.focusNode!;
    }
    controler = widget.controller ?? TextEditingController();
    _scroll.addListener(onMore);
    newData();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _insertOverlay();
      } else {
        _closeOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 40,
        child: ValidateTextField(
          textStyle: widget.textStyle,
          decoration: theme,
          controller: controler,
          focusNode: _focusNode,
          autofocus: widget.autoFocus ?? false,
          onChanged: (value) => _debouncer.run(newData),
        ),
      ),
    );
  }

  double get heightOverlay {
    final Size screenSize = MediaQuery.of(context).size;

    final hightDefault = screenSize.height * 0.4;
    final heightOverlay =
        value.items.isEmpty
            ? hightDefault
            : widget.itemHeight * value.items.length > hightDefault
            ? hightDefault
            : widget.itemHeight * value.items.length;
    return heightOverlay;
  }

  RenderBox get box => context.findRenderObject() as RenderBox;

  void _closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    return;
  }

  bool get shouldDisplayAbove {
    final offset = box.localToGlobal(Offset.zero);
    final Size screenSize = MediaQuery.of(context).size;
    return (offset.dy + box.size.height) >
        (screenSize.height - screenSize.height * 0.3);
  }

  void _insertOverlay() {
    _closeOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) {
        return StreamBuilder<OverlayItemsValue<T>>(
          stream: _streamController.stream,
          initialData: value,
          builder: (context, AsyncSnapshot snapshot) {
            return Positioned(
              width: box.size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  0,
                  shouldDisplayAbove
                      ? -heightOverlay - 60
                      : box.size.height + 5,
                ),
                child: Material(
                  elevation: widget.elevation,
                  color: widget.backgroundColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.grey79),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.hardEdge,
                    child: _buildOverlay(heightOverlay),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    return Overlay.of(context).insert(overlayEntry!);
  }

  Widget _buildOverlay(double height) {
    if (value.isLoad == true) {
      return SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (value.items.length < 4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.header != null) widget.header!,
          if (widget.header != null) const Divider(thickness: 1),
          _buildList(),
        ],
      );
    }
    return SizedBox(
      height: height,
      child: RefreshIndicator(
        onRefresh: () {
          newData();
          return Future.value();
        },
        child: SingleChildScrollView(
          padding: widget.padding ?? EdgeInsets.zero,
          controller: _scroll,
          physics:
              value.items.length > 3
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.header != null) widget.header!,
              if (widget.header != null) const Divider(thickness: 1),
              _buildList(),
              if (value.items.length > 3)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:
                      value.isMore != true
                          ? const SizedBox(height: 20)
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('Đang tải', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (value.items.isEmpty) {
      return Center(child: const Text("Chưa có dữ liệu").padding(32.padingVer));
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: value.items.length,
      separatorBuilder:
          (context, index) => widget.separator ?? const Divider(height: 1),
      itemBuilder:
          (context, index) => SizedBox(
            height: widget.itemHeight,
            child: InkWell(
              onTap: () {
                widget.onChanged?.call(value.items[index]);
                _focusNode.unfocus();
              },
              child: widget.itemBuilder(context, value.items[index], index),
            ),
          ),
    );
  }

  InputDecoration get theme {
    return InputDecoration(
      label:
          widget.label == null
              ? null
              : RichText(
                text: TextSpan(
                  text: widget.label,
                  style: const TextStyle(color: Colors.black),
                  children: [if (widget.isRequired) const TextSpan(text: '*')],
                ),
              ),
      hintText: widget.hintText ?? 'Nhập từ khoá',
      hintStyle:
          widget.hintStyle ?? const TextStyle(fontSize: 14, color: Colors.grey),
      contentPadding:
          widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      border: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: widget.focusedBorderColor),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: widget.focusedBorderColor),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
      suffixIcon: widget.suffix,
      prefixIcon: widget.prefix,
    );
  }

  OutlineInputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(widget.borderRadius),
    borderSide: BorderSide(color: widget.enabledBorderColor),
  );

  void newData() async {
    value.isLoad = true;
    value.isMore = false;
    value.items.clear();
    _streamController.sink.add(value);
    final list = await widget.lazyLoad?.call(false);
    value.items = list ?? [];
    value.isLoad = false;
    value.isMore = false;
    _streamController.sink.add(value);
  }

  void getData() async {
    if (value.items.isNotEmpty) {
      value.isLoad = false;
      value.isMore = true;
    } else {
      value.isLoad = true;
      value.isMore = false;
    }

    _streamController.sink.add(value);
    final list = await widget.lazyLoad?.call(true);
    value.items.addAll(list ?? []);
    value.isLoad = false;
    value.isMore = false;
    _streamController.sink.add(value);
  }

  void onMore() async {
    if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
      getData();
    }
  }
}

class OverlayItemsValue<T> {
  List<T> items;
  bool isLoad;
  bool isMore;
  OverlayItemsValue({
    required this.items,
    this.isLoad = false,
    this.isMore = false,
  });
}
