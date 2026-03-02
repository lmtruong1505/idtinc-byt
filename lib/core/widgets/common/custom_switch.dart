import 'package:flutter/material.dart';
import 'package:tasa/core/constants/typography.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final String? label;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _circleAnimation = AlignmentTween(
      begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
      end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color:
                      _circleAnimation!.value == Alignment.centerLeft
                          ? Colors.grey
                          : Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Container(
                    alignment:
                        !widget.value
                            ? ((Directionality.of(context) == TextDirection.rtl)
                                ? Alignment.centerRight
                                : Alignment.centerLeft)
                            : ((Directionality.of(context) == TextDirection.rtl)
                                ? Alignment.centerLeft
                                : Alignment.centerRight),
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.label != null) const SizedBox(width: 6),
              if (widget.label != null)
                Text(widget.label!, style: AppTypography.p4),
            ],
          ),
        );
      },
    );
  }
}
