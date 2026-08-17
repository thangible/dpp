import 'package:flutter/material.dart';

class DownloadInfoCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const DownloadInfoCard({super.key, this.animationController, this.animation});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 24),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 68, bottom: 12, right: 16, top: 12),
                                child: Text(
                                  'Click here to download report',
                                  textAlign: TextAlign.left,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Icon(
                          Icons.download,
                          size: 30,
                          color: colors.onPrimaryContainer,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
