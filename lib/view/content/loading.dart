import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool isDark;
  const Loading({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Data initialization  ',
            style: TextStyle(fontSize: 25.0),
          ),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 40),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                WavyAnimatedText('.....',
                    textStyle:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    speed: const Duration(milliseconds: 200)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
