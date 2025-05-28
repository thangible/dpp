
import 'package:flutter/material.dart';

import 'package:dpp/widgets/cards/glass_view.dart';
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
  Animation<double>? topBarAnimation;
  Animation<double>? cardAnimation;
  int count = 5; // Total number of items in the list

  
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  Future<List<String>> machineIds = ProductService.fetchMachineIds(); // Store keys from mock_data.json
  String selectedMachineId = ''; // Selected machineId from search

  @override
  void initState() {
    super.initState();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn)));
 // Fetch machine IDs from JSON
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() => topBarOpacity = 1.0);
        }
      } else if (scrollController.offset <= 24 && scrollController.offset >= 0) {
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


  void addAllListData() {
    listViews.clear(); // Clear existing list

    listViews.add(
      TitleView(
        titleTxt: 'Identifier',
        subTxt: 'Get QR Code',
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      ProductIdentifierCard(
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

    listViews.add(
      ProductSummaryCard(
        machineId: selectedMachineId.isNotEmpty ? selectedMachineId : "machine1",
        animation: cardAnimation,
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      GlassView(
          animation: cardAnimation,
          animationController: widget.animationController!),
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
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
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
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
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
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Products',
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 22 + 6 - 6 * topBarOpacity,
                                letterSpacing: 1.2,
                                color: AppTheme.darkerText,
                              ),
                            ),
                            // IconButton(
                            //   icon: const Icon(Icons.search),
                            //   onPressed: () {
                            //     showSearch(
                            //       context: context,
                            //       delegate: MachineIdSearchDelegate(machineIds,
                            //           onSelected: (String selectedId) {
                            //         setState(() {
                            //           selectedMachineId = selectedId;
                            //           addAllListData(); // Refresh the list
                            //         });
                            //       })
                            //     );
                            //   },
                            // ),
                            SearchBarWidget()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class MachineIdSearchDelegate extends SearchDelegate<String> {
  final List<String> machineIds;
  final ValueChanged<String> onSelected;

  MachineIdSearchDelegate(this.machineIds, {required this.onSelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        machineIds.where((id) => id.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: results
          .map((id) => ListTile(
                title: Text(id),
                onTap: () {
                  onSelected(id);
                  close(context, id);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = machineIds
        .where((id) => id.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: suggestions
          .map((id) => ListTile(
                title: Text(id),
                onTap: () {
                  onSelected(id);
                  close(context, id);
                },
              ))
          .toList(),
    );
  }
}
