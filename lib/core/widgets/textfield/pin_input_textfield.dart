import 'package:flutter/material.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/typography.dart';

class PinInputField extends StatefulWidget {
  final Function(String)? onDone;
  final TextEditingController? ctrl;
  final String? Function(String?)? validator;

  const PinInputField({super.key, this.onDone, this.ctrl, this.validator});
  @override
  PinInputFieldState createState() => PinInputFieldState();
}

class PinInputFieldState extends State<PinInputField> {
  bool _obscureText = true;
  // Trạng thái ẩn/hiện

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      controller: widget.ctrl,
      maxLength: 6, // Giới hạn 6 ký tự
      textAlign: TextAlign.center, // Canh giữa chữ
      obscureText: _obscureText, // Ẩn ký tự nhập vào
      style: s16w500.copyWith(
        color: AppColors.black,
      ), // Kích thước chữ và khoảng cách
      keyboardType: TextInputType.number,
      // Bàn phím số
      onChanged: (value) {
        if (widget.onDone != null) {
          if (value.length == 6) {
            widget.onDone!.call(value);
          }
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        counterText: "", // Ẩn đếm ký tự dưới TextField
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.grey79),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Chuyển trạng thái ẩn/hiện
            });
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.main),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.border_2, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.red_1, width: 1.2),
        ),
      ),
    );
  }
}
