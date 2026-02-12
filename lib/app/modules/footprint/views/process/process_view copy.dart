import 'package:flutter/material.dart';
import 'package:dpp/app/modules/footprint/views/widgets/cards/download_info_card.dart';
import 'package:dpp/app/modules/footprint/views/widgets/title_view.dart';
import 'package:dpp/config/theme/app_theme.dart';
import 'package:dpp/app/modules/footprint/views/widgets/cards/process_identifier_card.dart';
import 'package:dpp/app/modules/footprint/views/widgets/subwidgets/search_bar.dart';
import 'package:dpp/app/services/test/process_service.dart';
import 'package:dpp/app/data_model/test/process.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key, this.animationController});

  final AnimationController? animationController;

  @override
  _ProcessScreenState createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen>
    with TickerProviderStateMixin {
  // Animation
  Animation<double>? topBarAnimation;
  Animation<double>? cardAnimation;
  int count = 5;

  // State variables
  String _selectedProcessId = "";
  List<Widget> listViews = <Widget>[];

  // Process Information
  Process? process;

  // ScrollController and top bar opacity
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    topBarOpacity = 1.0;
    widget.animationController?.forward();

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    _initializeServices();
    addCards();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() => topBarOpacity = 1.0);
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() => topBarOpacity = scrollController.offset / 24);
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() => topBarOpacity = 0.0);
        }
      }
    });
  }

  Future<void> _initializeServices() async {
    await ProcessService.init();
  }

  Future<void> loadDataAfterSearch(String processId) async {
    final data = ProcessService.getProcessById(processId);
    setState(() {
      process = data;
      _selectedProcessId = processId;
    });
    addCards(); // Refresh cards with new data
  }

  void addCards() {
    listViews.clear();

    if (process != null) {
      // Identifier Section
      listViews.add(
        TitleView(
          titleTxt: 'Process Identifier',
          subTxt: 'Get QR Code',
          productID: process!.id,
          product: null, // We're dealing with processes, not products
          animation: cardAnimation,
          animationController: widget.animationController!,
        ),
      );

      listViews.add(
        ProcessIdentifierCard(
          animation: cardAnimation,
          animationController: widget.animationController!,
          id: process!.id,
          manufacturer: process!.manufacturer,
          material: process!.material,
          progress: process!.progress,
          lastUpdated: process!.lastUpdated,
        ),
      );

      // Summary Section
      listViews.add(
        TitleView(
          titleTxt: 'Process Summary',
          subTxt: 'Details',
          animation: cardAnimation,
          animationController: widget.animationController!,
        ),
      );

      // Download Section
      // listViews.add(
      //   DownloadInfoCard(
      //     product: null, // Pass null since this is for processes
      //     // You might want to create a Process-specific download card
      //     // or modify DownloadInfoCard to accept Process objects
      //     animation: cardAnimation,
      //     animationController: widget.animationController!,
      //   ),
      // );
    } else {
      // Show empty state or instructions
      listViews.add(
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.precision_manufacturing,
                size: 64,
                color: AppTheme.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No Process Selected',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Use the search bar above to find and select a process',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 14,
                  color: AppTheme.grey.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: ListView.builder(
              key: ValueKey<String>(_selectedProcessId),
              controller: scrollController,
              padding: EdgeInsets.only(
                top:
                    AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    24,
                bottom: 62 + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: listViews.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                widget.animationController?.forward();
                return listViews[index];
              },
            ),
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30 * (1.0 - topBarAnimation!.value),
                  0.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                'Process',
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22 + 6 - 6 * topBarOpacity,
                                  letterSpacing: 1.2,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: SearchBarWidget(
                                searchType: SearchBarType.process,
                                onItemSelected: (
                                  String selectedProcessId,
                                ) async {
                                  print("Process selected: $selectedProcessId");
                                  await loadDataAfterSearch(selectedProcessId);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
