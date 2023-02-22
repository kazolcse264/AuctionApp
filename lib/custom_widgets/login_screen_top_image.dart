import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("images/login.svg"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}