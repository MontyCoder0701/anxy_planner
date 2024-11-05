import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import your localization class
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
  late final settingProvider = context.read<SettingProvider>();

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final List<List<Widget>> tourSlides = [
      [
        Text(tr.tourDialogSlide1Text1),
        Text(tr.tourDialogSlide1Text2),
      ],
      [
        Text(tr.tourDialogSlide2Text1),
        Text(tr.tourDialogSlide2Text2),
      ],
      [
        Text(tr.tourDialogSlide3Text1),
        Text(tr.tourDialogSlide3Text2),
      ],
      [
        Text(
          tr.tourDialogSlide4Text1,
          style: CustomTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          tr.tourDialogSlide4Text2,
          style: CustomTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(tr.tourDialogSlide4Text3),
      ],
    ];

    return AlertDialog(
      title: const Text('One Moon.'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
