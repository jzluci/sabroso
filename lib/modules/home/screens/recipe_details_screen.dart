import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';


import '../../../utils/AppColor.dart';

class RecipeDetailPage extends StatefulWidget {

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {
          appBarColor = AppColor.primary;
        });
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.secondary),
        title: Text(
          "Recipe Details",
          style: TextStyle(
              color: AppColor.secondary,
              fontWeight: FontWeight.w700,
              fontFamily: 'inter',
              fontSize: 25),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        actions: [
          //search bar left
          Container(
            margin: EdgeInsets.only(left: 16),
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: AppColor.secondary, size: 30,),
            ),
          ),
        ],
      ),
      // Post Review FAB
      floatingActionButton: Visibility(
        visible: showFAB(_tabController),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      color: Colors.white,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Write your review here...',
                        ),
                        maxLines: null,
                      ),
                    ),
                    actions: [
                      Row(
                        children: [
                          Container(
                            width: 120,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('cancel'),
                              style: TextButton.styleFrom(
                                primary: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Post Review'),
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                });
          },
          child: Icon(Icons.edit),
          backgroundColor: AppColor.primary,
        ),
      ),
      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Recipe Image
          GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(gradient: AppColor.linearBlackTop),
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            color: AppColor.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Calories and Time
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/fire-filled.svg',
                      color: Colors.white,
                      width: 16,
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "calories",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.alarm, size: 16, color: Colors.white),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "Time",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                // Recipe Title
                Container(
                  margin: EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    "Title",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'inter'),
                  ),
                ),
                // Recipe Description
                Text(
                  "Description",
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 150 / 100),
                ),
              ],
            ),
          ),
          // Tabbar ( Ingridients, Tutorial, Reviews )
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              labelStyle: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w500),
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Ingridients',
                ),
                Tab(
                  text: 'Tutorial',
                ),
                Tab(
                  text: 'Reviews',
                ),
              ],
            ),
          ),
          // IndexedStack based on TabBar index
          IndexedStack(
            index: _tabController.index,
            children: [
              // Ingridients
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: 8,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    child: Text("ingredients"),
                  );
                },
              ),
              // Tutorials
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: 7,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    child: Text("steps"),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
