import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/textfield/input_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum _CalendarView { days, months, years }

class CommonDatePicker extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Function(DateTime) onConfirm;
  final bool isRequired;
  final String? hintText;

  const CommonDatePicker({
    super.key,
    required this.label,
    this.initialValue,
    required this.onConfirm,
    this.isRequired = false,
    this.hintText,
  });

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  late TextEditingController _controller;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late DateTime _focusedDate;
  DateTime? _selectedDate;
  _CalendarView _currentView = _CalendarView.days;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _selectedDate =
        widget.initialValue != null && widget.initialValue!.isNotEmpty
            ? _parseDate(widget.initialValue!)
            : null;
    _focusedDate = _selectedDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(CommonDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text = widget.initialValue ?? '';
        _selectedDate =
            widget.initialValue != null && widget.initialValue!.isNotEmpty
                ? _parseDate(widget.initialValue!)
                : null;
        if (_selectedDate != null) {
          _focusedDate = _selectedDate!;
        }
      });
    }
  }

  @override
  void dispose() {
    _hideCalendar();
    _controller.dispose();
    super.dispose();
  }

  DateTime? _parseDate(String text) {
    try {
      final parts = text.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (year < 1900 || year > 2100) return null;
      if (month < 1 || month > 12) return null;

      final daysInMonth = DateTime(year, month + 1, 0).day;
      if (day < 1 || day > daysInMonth) return null;

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  void _onTextChanged(String value) {
    final date = _parseDate(value);
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _focusedDate = date;
      });
    }
  }

  void _onSubmitted(String value) {
    final date = _parseDate(value);
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _focusedDate = date;
      });
      widget.onConfirm(date);
    }
    _hideCalendar(); // Hide calendar when confirming via keyboard
  }

  void _showCalendar() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideCalendar() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const double calendarWidth = 320.0;
    const double calendarHeight = 350.0; // Estimated height

    // Horizontal: Always center of screen
    double left = (screenWidth - calendarWidth) / 2;

    // Vertical: Below the field, or above if no space
    double top = offset.dy + size.height + 8;
    if (top + calendarHeight > screenHeight - 16) {
      top = offset.dy - calendarHeight - 8;
    }

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Background to dismiss on tap
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideCalendar,
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.black.withOpacity(0.05)),
                ),
              ),
              // Positioned calendar
              Positioned(
                top: top,
                left: left,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    width: calendarWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: _buildCalendar(),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildCalendar() {
    return StatefulBuilder(
      builder: (context, setPickerState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Month, Year and Circular Nav Buttons
            Row(
              children: [
                _buildMonthSelector(setPickerState),
                8.width,
                _buildYearSelector(setPickerState),
                const Spacer(),
                if (_currentView == _CalendarView.days) ...[
                  _buildNavButton(
                    icon: Icons.chevron_left,
                    onPressed: () {
                      setPickerState(() {
                        _focusedDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month - 1,
                        );
                      });
                    },
                  ),
                  8.width,
                  _buildNavButton(
                    icon: Icons.chevron_right,
                    onPressed: () {
                      setPickerState(() {
                        _focusedDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month + 1,
                        );
                      });
                    },
                  ),
                ] else
                  _buildNavButton(
                    icon: Icons.close,
                    onPressed: () {
                      setPickerState(() {
                        _currentView = _CalendarView.days;
                      });
                    },
                  ),
              ],
            ),
            16.height,
            if (_currentView == _CalendarView.days) ...[
              // Weekday labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                        .map(
                          (d) => SizedBox(
                            width: 32,
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: AppTypography.p5.copyWith(
                                color: AppColors.grey60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
              12.height,
              // Days grid
              _buildDaysGrid(setPickerState),
            ] else if (_currentView == _CalendarView.months)
              _buildMonthPicker(setPickerState)
            else
              _buildYearPicker(setPickerState),
          ],
        );
      },
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.text_primary),
      ),
    );
  }

  Widget _buildMonthSelector(StateSetter setPickerState) {
    return InkWell(
      onTap: () {
        setPickerState(() {
          _currentView =
              _currentView == _CalendarView.months
                  ? _CalendarView.days
                  : _CalendarView.months;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F3),
          borderRadius: BorderRadius.circular(4),
          border:
              _currentView == _CalendarView.months
                  ? Border.all(color: AppColors.main, width: 1)
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tháng ${_focusedDate.month}',
              style: AppTypography.p5.copyWith(fontWeight: FontWeight.w500),
            ),
            8.width,
            Icon(
              _currentView == _CalendarView.months
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.grey80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector(StateSetter setPickerState) {
    return InkWell(
      onTap: () {
        setPickerState(() {
          _currentView =
              _currentView == _CalendarView.years
                  ? _CalendarView.days
                  : _CalendarView.years;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F3),
          borderRadius: BorderRadius.circular(4),
          border:
              _currentView == _CalendarView.years
                  ? Border.all(color: AppColors.main, width: 1)
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_focusedDate.year}',
              style: AppTypography.p5.copyWith(fontWeight: FontWeight.w500),
            ),
            8.width,
            Icon(
              _currentView == _CalendarView.years
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.grey80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker(StateSetter setPickerState) {
    return SizedBox(
      height: 240,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final isSelected = _focusedDate.month == index + 1;
          return InkWell(
            onTap: () {
              setPickerState(() {
                _focusedDate = DateTime(_focusedDate.year, index + 1);
                _currentView = _CalendarView.days;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF262C36) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border:
                    !isSelected ? Border.all(color: AppColors.grey20) : null,
              ),
              child: Text(
                'Tháng ${index + 1}',
                style: AppTypography.p5.copyWith(
                  color: isSelected ? Colors.white : AppColors.text_primary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearPicker(StateSetter setPickerState) {
    final currentYear = DateTime.now().year;
    return SizedBox(
      height: 240,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 101, // 50 years back, 50 forward
        itemBuilder: (context, index) {
          final year = currentYear - 50 + index;
          final isSelected = _focusedDate.year == year;
          return InkWell(
            onTap: () {
              setPickerState(() {
                _focusedDate = DateTime(year, _focusedDate.month);
                _currentView = _CalendarView.days;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF262C36) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border:
                    !isSelected ? Border.all(color: AppColors.grey20) : null,
              ),
              child: Text(
                '$year',
                style: AppTypography.p5.copyWith(
                  color: isSelected ? Colors.white : AppColors.text_primary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaysGrid(StateSetter setPickerState) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final daysInMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final weekdayOfFirst = firstDayOfMonth.weekday;

    List<Widget> dayWidgets = [];
    for (int i = 1; i < weekdayOfFirst; i++) {
      dayWidgets.add(const SizedBox(width: 36, height: 36));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isSelected =
          _selectedDate != null &&
          _selectedDate!.day == day &&
          _selectedDate!.month == _focusedDate.month &&
          _selectedDate!.year == _focusedDate.year;

      final isToday = isSameDay(date, DateTime.now());

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
              _controller.text = DateFormat('dd/MM/yyyy').format(date);
            });
            widget.onConfirm(date);
            _hideCalendar();
          },
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF262C36) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border:
                  isToday && !isSelected
                      ? Border.all(color: const Color(0xFF262C36), width: 1)
                      : null,
            ),
            child: Text(
              '$day',
              style: AppTypography.p5.copyWith(
                color: isSelected ? Colors.white : AppColors.text_primary,
                fontWeight:
                    (isSelected || isToday) ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: dayWidgets);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputColumnComfirm(
        label: widget.label,
        isRequired: widget.isRequired,
        hintText: widget.hintText ?? 'Chọn',
        controller: _controller,
        onChanged: _onTextChanged,
        onSubmitted: _onSubmitted,
        onTap: _showCalendar,
        readOnly: false,
        textInputType: TextInputType.datetime,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          _DateInputFormatter(),
          LengthLimitingTextInputFormatter(10),
        ],
        validate: (value) {
          if (widget.isRequired && (value == null || value.isEmpty)) {
            return 'Vui lòng nhập ${widget.label.toLowerCase()}';
          }
          if (value != null && value.isNotEmpty) {
            if (_parseDate(value) == null) {
              return 'Ngày không hợp lệ (dd/mm/yyyy)';
            }
          }
          return null;
        },
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_month_outlined,
            color: AppColors.grey80,
            size: 20,
          ),
          onPressed: _showCalendar,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length < oldValue.text.length) return newValue;
    if (text.length > 10) return oldValue;

    final buffer = StringBuffer();
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');

    for (int i = 0; i < digits.length; i++) {
      final char = digits[i];

      if (buffer.length == 0) {
        if (!RegExp(r'[0-3]').hasMatch(char)) {
          buffer.write('0');
          buffer.write(char);
          buffer.write('/');
          continue;
        }
      } else if (buffer.length == 1) {
        final firstDigit = int.parse(buffer.toString());
        final secondDigit = int.parse(char);
        if (firstDigit == 3 && secondDigit > 1) return oldValue;
        if (firstDigit == 0 && secondDigit == 0) return oldValue;
        buffer.write(char);
        buffer.write('/');
        continue;
      } else if (buffer.length == 3) {
        if (!RegExp(r'[0-1]').hasMatch(char)) {
          buffer.write('0');
          buffer.write(char);
          buffer.write('/');
          continue;
        }
      } else if (buffer.length == 4) {
        final firstDigit = int.parse(buffer.toString().substring(3));
        final secondDigit = int.parse(char);
        if (firstDigit == 1 && secondDigit > 2) return oldValue;
        if (firstDigit == 0 && secondDigit == 0) return oldValue;
        buffer.write(char);
        buffer.write('/');
        continue;
      } else if (buffer.length >= 6 && buffer.length < 10) {
        buffer.write(char);
        continue;
      }

      buffer.write(char);
    }

    final newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
