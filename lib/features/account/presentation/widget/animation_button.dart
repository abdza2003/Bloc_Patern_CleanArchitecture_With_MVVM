import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_cafteria/core/constants/color_manager.dart';
import 'package:school_cafteria/core/util/hex_color.dart';
import 'package:school_cafteria/features/account/presentation/widget/button_widget.dart';
import 'package:sizer/sizer.dart';

class AnimationButtonWidget extends StatefulWidget {
  bool isAnimted;
  bool isLoading;
  String buttonText;
  var func;
  AnimationButtonWidget(
      {required this.isLoading,
      required this.isAnimted,
      required this.func,
      required this.buttonText,
      Key? key})
      : super(key: key);

  @override
  State<AnimationButtonWidget> createState() => _AnimationButtonWidgetState();
}

class _AnimationButtonWidgetState extends State<AnimationButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 7.h,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeIn,
      onEnd: () => setState(() => widget.isAnimted = !widget.isAnimted),
      constraints: BoxConstraints(
        maxWidth: !widget.isLoading ? 85.w : 25.w,
      ),
      child: !widget.isLoading
          ? MyButtonWidget(
              buttonText: widget.buttonText,
              func: widget.func,
            )
          : CircleAvatar(
              radius: 40,
              backgroundColor: HexColor('#8D6996'),
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
