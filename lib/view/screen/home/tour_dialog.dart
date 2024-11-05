import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/setting.dart';
import '../../theme.dart';

class TourDialog extends StatefulWidget {
  const TourDialog({super.key});

  @override
  TourDialogState createState() => TourDialogState();
}

class TourDialogState extends State<TourDialog> {
  int currentSlideIndex = 0;
  final List<List<Widget>> tourSlides = [
    [
      Text('너무 먼 미래를 생각하다보면 막막합니다.'),
      Text('한달 기준으로만 생각해보면 어떨까요?'),
    ],
    [
      Text('한달 기준으로만 투두를 작성해보세요.'),
      Text('의외로 삶이 간단해질 수 있습니다.'),
    ],
    [
      Text('느린 우체통처럼, '),
      Text('다음달 나를 위해 편지도 써보세요.'),
    ],
    [
      Text(
        '한달이 지나면 모든 투두는 초기화됩니다.',
        style: CustomTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text('이제 One Moon을 시작해볼까요?'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.read<SettingProvider>();

    return AlertDialog(
      title: const Text('One Moon.'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (Widget message in tourSlides[currentSlideIndex]) ...{message},
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        if (currentSlideIndex > 0)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() => currentSlideIndex--);
            },
          ),
        if (currentSlideIndex < tourSlides.length - 1)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() => currentSlideIndex++);
            },
          ),
        if (currentSlideIndex == tourSlides.length - 1)
          IconButton(
            icon: const Icon(
              Icons.check,
              color: CustomColor.primary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              settingProvider.completeTour();
            },
          ),
      ],
    );
  }
}
