import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/widgets/common/title_required.dart';

class ValidateTextField extends StatefulWidget {
  const ValidateTextField({
    Key? key,
    this.backgroundColor,
    this.radius,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.padding,
    this.margin,
    this.readOnly = false,
    this.trailingIcon,
    this.cursorColor,
    this.leadingIcon,
    this.focusNode,
    this.onChanged,
    this.obscureText = false,
    this.textInputType,
    this.border = true,
    this.maxLines,
    this.validator,
    this.formKey,
    this.errorStyle,
    this.initialValue,
    this.onTap,
    this.valueChange,
    this.defaultValue,
    this.emptySuffixIcon,
    this.onClear,
    this.isClear = false,
    this.autofocus,
    this.suffixIcon,
    this.inputFormatters,
    this.decoration,
    this.labelText,
    this.isRequired = false,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? cursorColor;
  final double? radius;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool readOnly;
  final bool? autofocus;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? textInputType;
  final bool? border;
  final bool? isClear;
  final int? maxLines;
  final String? Function(String?)? validator;
  final GlobalKey<FormState>? formKey;
  final TextStyle? errorStyle;
  final String? initialValue;
  final VoidCallback? onTap;
  final String? valueChange;
  final String? defaultValue;
  final Widget? emptySuffixIcon;
  final VoidCallback? onClear;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final String? labelText;
  final bool isRequired;

  @override
  State<ValidateTextField> createState() => _ValidateTextFieldState();
}

class _ValidateTextFieldState extends State<ValidateTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue)
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ValidateTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      // if (mounted) {
      //   _controller.text = widget.initialValue ?? '';
      //   setState(() {});
      // }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.initialValue ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("========TextFormFieldRebuild======");
    final textField = TextFormField(
      autofocus: widget.autofocus ?? false,
      controller: _controller,
      onTap: () => widget.onTap?.call(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: _focusNode,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      obscureText: widget.obscureText,
      maxLines: widget.maxLines ?? 1,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      inputFormatters: widget.inputFormatters,
      // scrollPadding: EdgeInsets.zero,
      readOnly: widget.readOnly,
      decoration:
          widget.decoration ??
          InputDecoration(
            hintText:
                widget.hintText ??
                (widget.labelText != null
                    ? "Nhập ${widget.labelText!.toLowerCase()}"
                    : ''),
            errorStyle: AppTypography.p7,
            filled: true,
            fillColor: widget.backgroundColor ?? AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color:
                    widget.border == true
                        ? AppColors.border_2
                        : Colors.transparent,
                width: widget.border == true ? 1 : 0,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 5,
              minHeight: 5,
            ),
            isDense: true,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 5,
              minHeight: 5,
            ),
            prefixIcon: Padding(
              padding: Spacing.l12,
              child: widget.leadingIcon,
            ),
            suffixIcon:
                widget.suffixIcon != null
                    ? Padding(padding: Spacing.r12, child: widget.suffixIcon)
                    : (_controller.text.isNotEmpty
                        ? Padding(
                          padding: Spacing.r12,
                          child:
                              widget.isClear == true &&
                                      _controller.text != widget.defaultValue
                                  ? GestureDetector(
                                    onTap: () {
                                      _controller.clear();
                                      widget.onClear?.call();
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: AppColors.grey_1,
                                    ),
                                  )
                                  : widget.emptySuffixIcon,
                        )
                        : Padding(
                          padding: Spacing.r12,
                          child:
                              (widget.emptySuffixIcon ??
                                  const SizedBox.shrink()),
                        )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color:
                    widget.border == true ? AppColors.main : Colors.transparent,
                width: widget.border == true ? 1.2 : 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color:
                    widget.border == true
                        ? AppColors.border_2
                        : Colors.transparent,
                width: widget.border == true ? 1.2 : 0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color:
                    widget.border == true
                        ? AppColors.red_1
                        : Colors.transparent,
                width: widget.border == true ? 1.2 : 0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color:
                    widget.border == true
                        ? AppColors.red_1
                        : Colors.transparent,
                width: widget.border == true ? 1.2 : 0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color:
                    widget.border == true
                        ? AppColors.border_2
                        : Colors.transparent,
                width: widget.border == true ? 1.2 : 0,
              ),
            ),
            contentPadding:
                widget.padding ??
                const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: 15.5,
                  top: 16.5,
                ),
            isCollapsed: true,
            hintStyle:
                widget.hintStyle ??
                AppTypography.p6.copyWith(color: AppColors.grey_1),
          ),
      cursorColor: widget.cursorColor ?? AppColors.bg_5,
      cursorWidth: 1,
      style: (widget.textStyle ?? AppTypography.p6).copyWith(
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (widget.labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_titleLayout(widget.labelText!), 8.height, textField],
      );
    }
    return textField;
  }

  Widget _titleLayout(String title) {
    if (widget.isRequired) {
      return requiredTitle(title);
    }
    return Text(
      title,
      style: AppTypography.p5.copyWith(color: AppColors.blackish),
    );
  }
}

class ValidateTextFieldV2 extends StatefulWidget {
  const ValidateTextFieldV2({
    Key? key,
    this.backgroundColor,
    this.radius,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.padding,
    this.margin,
    this.readOnly = false,
    this.trailingIcon,
    this.cursorColor,
    this.leadingIcon,
    this.focusNode,
    this.onChanged,
    this.obscureText = false,
    this.textInputType,
    this.border = true,
    this.maxLines,
    this.validator,
    this.formKey,
    this.errorStyle,
    this.initialValue,
    this.onTap,
    this.valueChange,
    this.defaultValue,
    this.emptySuffixIcon,
    this.onClear,
    this.isClear = false,
    this.autofocus,
    this.suffixIcon,
    this.labelText,
    this.isRequired = false,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? cursorColor;
  final double? radius;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool readOnly;
  final bool? autofocus;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? textInputType;
  final bool? border;
  final bool? isClear;
  final int? maxLines;
  final String? Function(String?)? validator;
  final GlobalKey<FormState>? formKey;
  final TextStyle? errorStyle;
  final String? initialValue;
  final VoidCallback? onTap;
  final String? valueChange;
  final String? defaultValue;
  final Widget? emptySuffixIcon;
  final VoidCallback? onClear;
  final String? labelText;
  final bool isRequired;

  @override
  State<ValidateTextFieldV2> createState() => _ValidateTextFieldV2State();
}

class _ValidateTextFieldV2State extends State<ValidateTextFieldV2> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue)
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ValidateTextFieldV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueChange != oldWidget.valueChange) {
      if (mounted) {
        _controller.text = widget.valueChange ?? '';
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      autofocus: widget.autofocus ?? false,
      controller: _controller,
      onTap: () {
        widget.onTap?.call();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: _focusNode,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      // scrollPadding: EdgeInsets.zero,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        hintText:
            widget.hintText ??
            (widget.labelText != null
                ? "Nhập ${widget.labelText!.toLowerCase()}"
                : ''),
        errorStyle: AppTypography.p7,
        filled: true,
        fillColor: widget.backgroundColor ?? AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
          borderSide: BorderSide(
            color:
                widget.border == true ? AppColors.border_2 : Colors.transparent,
            width: widget.border == true ? 1 : 0,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 5, minHeight: 5),
        isDense: true,
        suffixIconConstraints: const BoxConstraints(minWidth: 5, minHeight: 5),
        prefixIcon: Padding(padding: Spacing.l12, child: widget.leadingIcon),
        suffixIcon:
            widget.suffixIcon != null
                ? Padding(padding: Spacing.r12, child: widget.suffixIcon)
                : (_controller.text.isNotEmpty
                    ? Padding(
                      padding: Spacing.r12,
                      child:
                          widget.isClear == true &&
                                  _controller.text != widget.defaultValue
                              ? GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  widget.onClear?.call();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.grey_1,
                                ),
                              )
                              : widget.emptySuffixIcon,
                    )
                    : Padding(
                      padding: Spacing.r12,
                      child:
                          (widget.emptySuffixIcon ?? const SizedBox.shrink()),
                    )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
          borderSide: BorderSide(
            color: widget.border == true ? AppColors.main : Colors.transparent,
            width: widget.border == true ? 1.2 : 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
          borderSide: BorderSide(
            color:
                widget.border == true ? AppColors.border_2 : Colors.transparent,
            width: widget.border == true ? 1.2 : 0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
          borderSide: BorderSide(
            color: widget.border == true ? AppColors.red_1 : Colors.transparent,
            width: widget.border == true ? 1.2 : 0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
          borderSide: BorderSide(
            color: widget.border == true ? AppColors.red_1 : Colors.transparent,
            width: widget.border == true ? 1.2 : 0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
          borderSide: BorderSide(
            color:
                widget.border == true ? AppColors.border_2 : Colors.transparent,
            width: widget.border == true ? 1.2 : 0,
          ),
        ),
        contentPadding:
            widget.padding ??
            const EdgeInsets.only(left: 0, right: 0, bottom: 15.5, top: 16.5),
        isCollapsed: true,
        hintStyle:
            widget.hintStyle ??
            AppTypography.p6.copyWith(color: AppColors.grey_1),
      ),
      cursorColor: widget.cursorColor ?? AppColors.bg_5,
      cursorWidth: 1,
      style: widget.textStyle ?? AppTypography.p6,
    );

    if (widget.labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_titleLayout(widget.labelText!), 8.height, textField],
      );
    }
    return textField;
  }

  Widget _titleLayout(String title) {
    if (widget.isRequired) {
      return requiredTitle(title);
    }
    return Text(
      title,
      style: AppTypography.p5.copyWith(color: AppColors.blackish),
    );
  }
}
