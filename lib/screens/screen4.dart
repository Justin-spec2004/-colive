import 'package:flutter/material.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/img4.png"),
        SizedBox(
          height: 20,
        ),
        Text(
          tr(LocaleData.title4),
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            tr(LocaleData.body4),
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
