import 'package:dpp/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:dpp/styles/card_style.dart';
import 'package:dpp/styles/app_theme.dart';
import 'package:dpp/widgets/subwidgets/divider.dart';
import 'package:dpp/widgets/subwidgets/co2_counter.dart';
import 'package:dpp/widgets/subwidgets/macronutrient_row.dart';
import 'package:dpp/widgets/subwidgets/small_text.dart';

class ProcessIdentifierCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProcessIdentifierCard({
    super.key,
    this.animationController,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: buildCardTranslation(animation!.value),
            child: Padding(
              padding: cardPadding,
              child: Container(
                decoration: cardDecoration,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 4,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          bottom: 3,
                                        ),
                                        child: Text(
                                          '2024-08_Brackets',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                AppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                AppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: AppTheme.grey.withOpacity(
                                          0.5,
                                        ),
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4.0,
                                        ),
                                        child: Text(
                                          'Last updated: Today 8:27 AM',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                AppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: AppTheme.grey
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // SmallText(
                                  //   value: '100 nanometers',
                                  //   label: 'Layer height',
                                  // ),
                                  // const SizedBox(height: 8),
                                  // SmallText(
                                  //   value: '1.75 mm',
                                  //   label: 'Filament Diameter',
                                  // ),


                                  // const SizedBox(height: 8),
                                  // CO2Counter(
                                  //   label: 'Material',
                                  //   value: '${'PA 12'}',
                                  //   unit: 'kg',
                                  //   iconPath: "assets/fitness_app/burned.png",
                                  //   color: HexColor('#F56E98'),
                                  //   animationValue: animation!.value,
                                  // ),

                                  // SmallText(
                                  //   value: 'Material',
                                  //   label: 'PA 12',
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // Optional: for rounded corners
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Image.asset(
                                    'assets/images/machine_example.png',
                                    fit:
                                        BoxFit
                                            .cover, // Ensures it fills the box
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                        bottom: 8,
                      ),
                      child: CustomDivider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                        bottom: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'PA 12',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Material',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: AppTheme.grey.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '100 nanometers',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: AppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Layer height',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '1.75 mm',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: AppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Filament Diameter',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        value: 0.6,
                                        backgroundColor: AppTheme.grey.withOpacity(0.2),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppTheme.nearlyDarkBlue,
                                        ),
                                        strokeWidth: 6,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          '60%',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Progress',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: AppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
