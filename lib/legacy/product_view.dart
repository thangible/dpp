import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dpp/legacy/download_info_card.dart';
import 'package:dpp/legacy/title_view.dart';
import 'package:dpp/legacy/product_summary_card.dart';
import 'package:dpp/legacy/product_identifier_card.dart';
import 'package:dpp/legacy/search_bar_widget.dart';
//service
import 'package:dpp/app/services/test/product_service.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';

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
  Animation<double>? fadeAnimation;
  int count = 5;

  // State variables
  List<String> productIds = ProductService.productIds;
  String _selectedMachineId = "";
  List<Widget> listViews = <Widget>[];

  // Product Information
  Product? product;

  // ScrollController and top bar opacity
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  // Initialize the state and animations
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
        curve: Curves.easeOutCubic,
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
  Future<void> loadDataAfterSearch(String productId) async {
    final data = ProductService.getProductById(productId);
    setState(() {
      product = data;
    });
    if (data != null && Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().addEntry(
        productId,
        HistoryItemType.product,
      );
    }
  }

  // Add cards
  void addCards() {
    listViews.clear();

    if (product != null) {
      listViews.add(
        TitleView(
          titleTxt: 'Identifier',
          subTxt: 'Get QR Code',
          productID: product!.id.toString(),
          animation: cardAnimation,
          animationController: widget.animationController!,
        ),
      );

      listViews.add(
        ProductIdentifierCard(
          id: product!.id.toString(),
          lastUpdated: product!.lastUpdated,
          productType: product!.type,
          material: product!.material,
          manufacturer: product!.manufacturer,
          imagePath: product!.imagePath,
          animation: cardAnimation,
          animationController: widget.animationController!,
        ),
      );

      listViews.add(
        TitleView(
          titleTxt: 'Summary',
          subTxt: 'Details',
          productID: product!.id.toString(),
          product: product,
          animation: cardAnimation,
          animationController: widget.animationController!,
        ),
      );

      listViews.add(
        ProductSummaryCard(
          energyUsed: product!.energyUsed,
          co2Emissions: product!.co2Emissions,
          animation: cardAnimation,
          animationController: widget.animationController!,
        ),
      );

      listViews.add(
        DownloadInfoCard(
          // product: product,
          animation: cardAnimation,
          animationController: widget.animationController!,
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(context),
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
            duration: const Duration(milliseconds: 380),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.06, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: ListView.builder(
              key: ValueKey<String>(_selectedMachineId),
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

  Widget getAppBarUI(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
                    color: colors.surface.withValues(alpha: topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: colors.shadow.withValues(
                          alpha: 0.4 * topBarOpacity,
                        ),
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
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .center, // Changed from start to center
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                'Products',
                                style: textTheme.titleLarge?.copyWith(
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: SearchBarWidget(
                                searchType: SearchBarType.product,
                                onItemSelected: (
                                  String selectedProductId,
                                ) async {
                                  print("Machine selected: $selectedProductId");
                                  _selectedMachineId = selectedProductId;
                                  await loadDataAfterSearch(selectedProductId);
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
