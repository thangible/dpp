import 'package:flutter/material.dart';

import 'package:dpp/widgets/cards/download_info_card.dart';
import 'package:dpp/widgets/main_screens/title_view.dart';
import 'package:dpp/styles/app_theme.dart';
import 'package:dpp/widgets/cards/product_summary_card.dart';
import 'package:dpp/widgets/cards/product_identifier_card.dart';
import 'package:dpp/widgets/subwidgets/search_bar.dart';
//service
import 'package:dpp/services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.animationController});

  final AnimationController? animationController;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin {
  // Animation
  Animation<double>? topBarAnimation;
  Animation<double>? cardAnimation;
  int count = 5;

  // State variables
  Future<List<String>> machineIds = ProductService.fetchMachineIds();
  String _selectedMachineId = "";
  List<Widget> listViews = <Widget>[];

  // Product Information
  double? energyUsed;
  double? co2Emissions;
  int? id;
  DateTime? lastUpdated;
  String? type;
  String? material;
  String? manufacturer;
  double? virginMaterial;
  double? recycledMaterial;
  String? imagePath;

  // ScrollController and top bar opacity
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  // Initialize the state and animations
  @override
  void initState() {
    super.initState();
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

  // METHODS
  Future<void> loadDataAfterSearch(String machineId) async {
    final data = await ProductService.fetchProductSummaryData(machineId);
    setState(() {
      energyUsed = data['energyUsed'];
      co2Emissions = data['co2Emissions'];
      id = data['id'];
      lastUpdated = DateTime.tryParse(data['lastUpdated'] ?? '');
      type = data['type'];
      material = data['material'];
      manufacturer = data['manufacturer'];
      virginMaterial = data['virginMaterial'];
      recycledMaterial = data['recycledMaterial'];
      imagePath = data['imagePath'];
      // print('Energy Used: $energyUsed');
      // print('CO2 Emissions: $co2Emissions');
      // print('ID: $id');
      // print('Last Updated: $lastUpdated');
      // print('Type: $type');
      // print('Material: $material');
      // print('Manufacturer: $manufacturer');
      // print('Virgin Material: $virginMaterial');
      // print('Recycled Material: $recycledMaterial');
      // print('Image Link: $imagePath');
    });
  }

  // Add cards
  void addCards() {
    listViews.clear();

    listViews.add(
      TitleView(
        titleTxt: 'Identifier',
        subTxt: 'Get QR Code',
        productID: id?.toString() ?? '',
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      ProductIdentifierCard(
        id: id?.toString() ?? 'N/A',
        lastUpdated: lastUpdated ?? DateTime.now(),
        productType: type ?? 'Unknown',
        material: material ?? 'Unknown',
        manufacturer: manufacturer ?? 'Unknown',
        imagePath: imagePath ?? '',
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Summary',
        subTxt: 'Details',
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );

     // 🔶 Only show summary card if data is loaded
  if (energyUsed != null && co2Emissions != null) {
    listViews.add(
      ProductSummaryCard(
        energyUsed: energyUsed!,
        co2Emissions: co2Emissions!,
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );
  }

    listViews.add(
      DownloadInfoCard(
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );
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
              key: ValueKey<String>(_selectedMachineId), // 🔥 Key changes here
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
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                'Products',
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22 + 6 - 6 * topBarOpacity,
                                  letterSpacing: 1.2,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: SearchBarWidget(
                                onMachineSelected: (String selectedMachineId) async {
                                  print("Machine selected: $selectedMachineId");
                                  _selectedMachineId = selectedMachineId;
                                  await loadDataAfterSearch(selectedMachineId);
                                  addCards(); // Refresh list with animation
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
