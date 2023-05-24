// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, no_logic_in_create_state
import 'package:dio/dio.dart';
import 'package:final_project_year/bloc/location/cubit/choice_cubit.dart';
import 'package:final_project_year/common_component/card_board.dart';
import 'package:final_project_year/common_component/google_map.dart';
import 'package:final_project_year/common_component/main_diwer.dart';
import 'package:final_project_year/common_component/pie_chart.dart';
import 'package:final_project_year/common_component/search_field.dart';
import 'package:final_project_year/common_component/select_location.dart';
import 'package:final_project_year/common_component/signup_dropdown_button.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../apis/apis_functions.dart';

/*


*/

class DashBoardScreen extends StatefulWidget {
  GoogleMapComponentDashBoardScreen con =
      const GoogleMapComponentDashBoardScreen();
  DashBoardScreen({super.key});
  Widget wid = StatisticFarm();
  @override
  State<DashBoardScreen> createState() {
    return _DashBoardScreenState(googleMapComponentDashBoardScreen: con);
  }
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  _DashBoardScreenState({required this.googleMapComponentDashBoardScreen});
  ScrollController con = ScrollController();
  GoogleMapComponentDashBoardScreen googleMapComponentDashBoardScreen;

  @override
  Widget build(BuildContext context) {
    SliverPadding;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: dashBoard(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.data != null &&
                  snap.data!.isNotEmpty) {
                return LayoutBuilder(builder: (context, constraint) {
                  return Scaffold(
                    key: scaffoldKey,
                    drawer: constraint.maxWidth < 1900.0
                        ? const CustomeDrawerView2()
                        : null,
                    backgroundColor: const Color(0xFFf3f3f5),
                    body: Row(
                      children: [
                        constraint.maxWidth >= 1920.0
                            ? const CustomeDrawerView2()
                            : Container(),
                        Expanded(
                            child: NestedScrollView(
                                controller: con,
                                headerSliverBuilder:
                                    (context, innerBoxIsScrolled) {
                                  return [
                                    SliverList(
                                      delegate: SliverChildListDelegate([
                                        Row(children: [
                                          constraint.maxWidth < 1920.0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.menu,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        scaffoldKey
                                                            .currentState!
                                                            .openDrawer();
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ]),
                                        constraint.maxWidth > 1920.0
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.menu,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      scaffoldKey.currentState!
                                                          .openDrawer();
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        Container(height: 10),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            CustomeDropdownButtomSignUp(
                                                value: 12),
                                            SizedBox(
                                              width: 300,
                                              child: SearchTextField(
                                                  width: constraint.maxWidth >=
                                                          500
                                                      ? 600 - 200
                                                      : constraint.maxWidth -
                                                          200),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 10,
                                        ),
                                        Wrap(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0),
                                                    child: Wrap(
                                                      runAlignment:
                                                          WrapAlignment
                                                              .spaceBetween,
                                                      spacing: 12,
                                                      runSpacing: 12,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .start,
                                                      children: [
                                                        CardDashBoard(
                                                            value: snap
                                                                .data!['data'][
                                                                    'farm_milk']
                                                                .toString(),
                                                            icon: const Icon(
                                                                Icons
                                                                    .description,
                                                                color: Colors
                                                                    .blue),
                                                            color: Colors.blue,
                                                            title:
                                                                'مزارع  اللبان'),
                                                                
                                                        CardDashBoard(
                                                            value: snap
                                                                .data!['data'][
                                                                    'farm_meat']
                                                                .toString(),
                                                            right: 20,
                                                            icon: const Image(
                                                                image: AssetImage(
                                                                    'assets/icons/driver_google.png')),
                                                            color: Colors.amber,
                                                            title:
                                                                'عدد مزارع اللحوم'),
                                                        CardDashBoard(
                                                            value: snap
                                                                .data!['data'][
                                                                    'farmer_count']
                                                                .toString(),
                                                            right: 20,
                                                            icon: const Icon(
                                                                Icons.cloud,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        188,
                                                                        76,
                                                                        76)),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                188,
                                                                76,
                                                                76),
                                                            title:
                                                                'عدد المربين'),
                                                        CardDashBoard(
                                                            value: snap
                                                                .data!['data'][
                                                                    'village_count']
                                                                .toString(),
                                                            right: 20,
                                                            icon: const Icon(
                                                                Icons
                                                                    .access_time_outlined,
                                                                color: Colors
                                                                    .blue),
                                                            color: Colors.blue,
                                                            title:
                                                                'عدد الاماكن'),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(height: 40),
                                                  Container(height: 30),
                                                  googleMapComponentDashBoardScreen
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                        constraint.maxWidth < 1900.0
                                            ? TotalStatisticsPieChart(
                                                width: 300,
                                                statistic: [
                                                  snap.data!['data']
                                                      ['total_beauty'],
                                                  snap.data!['data']
                                                      ['total_sheep'],
                                                  snap.data!['data']
                                                      ['total_cows']
                                                ],
                                              )
                                            : Container(),
                                        Container(
                                          height: 30,
                                        ),
                                      ]),
                                    ),
                                  ];
                                },
                                body: widget.wid)),
                        constraint.maxWidth >= 1900.0
                            ? TotalStatisticsPieChart(
                                width: 400,
                                statistic: [
                                  snap.data!['data']['total_beauty'],
                                  snap.data!['data']['total_sheep'],
                                  snap.data!['data']['total_cows']
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  );
                });
              } else {
                return const Column(
                  children: [
                    Spacer(),
                    Row(
                      children: [
                        Spacer(),
                        SizedBox(
                            height: 40,
                            width: 100,
                            child: CircularProgressIndicator.adaptive()),
                        Spacer()
                      ],
                    ),
                    Spacer(),
                  ],
                );
              }
            }));
  }
}

class StatisticFarm extends StatefulWidget {
  List<Map<String, dynamic>> list1 = [];
  LocationCubit locationCubit = LocationCubit(
    city: -1,
    gavernorate: -1,
    village: -1,
  );
  SelectLocationDashBoard selectLocationDashBoard = SelectLocationDashBoard();
  StatisticFarm({
    super.key,
    this.list1 = const [],
  });

  @override
  State<StatisticFarm> createState() => _StatisticFarmState();
}

class _StatisticFarmState extends State<StatisticFarm> {
  String drop = "farm_meat_gov";
  ScrollController con = ScrollController();
  bool ini = false;
  @override
  Widget build(BuildContext context) {
    //print(widget.list1);
    return FutureBuilder(
        future: location_api(stop: ini),
        builder: (context, snap) {
          // print(snap.data);
          if (snap.connectionState == ConnectionState.done &&
              snap.data != null &&
              (snap.data!.isNotEmpty || ini)) {
            widget.locationCubit = LocationCubit(
                gavernorate: !ini
                    ? snap.data![0]['governorate']
                    : widget.locationCubit.state.gavernorate,
                city: !ini
                    ? snap.data![0]['city']
                    : widget.locationCubit.state.city,
                village: !ini
                    ? snap.data![0]['village']
                    : widget.locationCubit.state.village);
            print(widget.locationCubit.state.city);
            ini = true;
            return BlocProvider(
              create: (context) => widget.locationCubit,
              child: ListView.separated(
                  itemCount: widget.list1.length + 2,
                  separatorBuilder: (context, index) {
                    return Container();
                  },
                  cacheExtent: 10,
                  clipBehavior: Clip.none,
                  physics: const ClampingScrollPhysics(),
                  reverse: false,
                  padding: const EdgeInsets.all(30),
                  itemBuilder: (context, index) {
                    // print(widget.list1.length);
                    if (index == 0) {
                      return Builder(builder: (context) {
                        return widget.selectLocationDashBoard;
                      });
                    }
                    if (index == 1) {
                      return Builder(builder: (context) {
                        return BlocListener<LocationCubit, LocationState>(
                          listenWhen: (previous, current) {
                            return true;
                          },
                          bloc: widget.locationCubit,
                          listener: (context, state) async {
                            print(state.city);
                            print("*" * 789);
                            if (state.gavernorate == -1) {
                              List<dynamic> u = ((await location_dash_info(
                                  formData: FormData.fromMap(
                                      {"type": "gov"}))))["gov_data"];
                              widget.list1 = [];
                              for (var i in u) {
                                widget.list1.add(i);
                              }
                              setState(() {});
                            } else if (state.city == -1) {
                              List<dynamic> u = (await location_dash_info(
                                  formData: FormData.fromMap({
                                "id": state.gavernorate,
                                "type": "city"
                              })))["gov_data"];
                              widget.list1 = [];
                              for (var i in u) {
                                widget.list1.add(i);
                              }
                              setState(() {});
                            } else {
                              // print(state.city);
                              List<dynamic> u = ((await location_dash_info(
                                  formData: FormData.fromMap({
                                "type": "village",
                                "id": state.city
                              })))["gov_data"]);
                              //print(widget.list1);
                              widget.list1 = [];
                              for (var i in u) {
                                widget.list1.add(i);
                              }
                              setState(() {});
                            }
                          },
                          child: Container(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'المحافظة',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                )),
                                const Expanded(
                                    child: Text(
                                  'عدد الرؤوس',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                )),
                                SizedBox(
                                  width: 80,
                                  child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    focusColor: Colors.transparent,
                                    isExpanded: true,
                                    underline: Container(),
                                    alignment: Alignment.center,
                                    borderRadius: BorderRadius.circular(0),
                                    value: drop,
                                    items: const [
                                      DropdownMenuItem<String>(
                                          alignment: Alignment.center,
                                          value: "farm_meat_gov",
                                          child: Text('مزارع اللحوم')),
                                      DropdownMenuItem<String>(
                                          alignment: Alignment.center,
                                          value: "farm_milk_gov",
                                          child: Text('مزارع الالبان')),
                                      DropdownMenuItem<String>(
                                          alignment: Alignment.center,
                                          value: "total_villages",
                                          child: Text('عدد القري'))
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        drop = value ?? drop;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    } else {
                      print(index);
                      return Card(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                widget.list1[index - 2]['g_name'],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.list1[index - 2][drop].toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            );
          }

          return Container();
        });
  }
}

class CustomeSearch extends StatefulWidget {
  CustomeSearch({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  String text;
  double width;

  @override
  State<CustomeSearch> createState() => _CustomeSearchState();
}

class _CustomeSearchState extends State<CustomeSearch> {
  double height = 100;
  bool visiable = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                if (value.isEmpty && visiable) {
                  setState(() {
                    visiable = false;
                  });
                } else if (!visiable) {
                  setState(() {
                    height = 200;
                    visiable = true;
                  });
                }
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ادخل اسم المزارع او المزرعة',
                  suffixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white),
            ),
            Visibility(
              visible: visiable,
              child: Expanded(
                  child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black))),
                            child: IconButton(
                                style: const ButtonStyle(),
                                onPressed: () {
                                  setState(() {
                                    visiable = false;
                                    height = 100;
                                  });
                                },
                                icon: const Row(
                                  children: [
                                    Image(
                                      height: 50,
                                      width: 50,
                                      image: NetworkImage(
                                          'https://www.agri2day.com/wp-content/uploads/2019/04/-%D9%85%D8%B2%D8%A7%D8%B1%D8%B9-%D8%A7%D9%84%D8%A5%D9%86%D8%AA%D8%A7%D8%AC-%D8%A7%D9%84%D8%AD%D9%8A%D9%88%D8%A7%D9%86%D9%8A-%D8%A8%D8%A7%D9%84%D8%B4%D8%B1%D9%82%D9%8A%D8%A9-e1554558511203.jpeg'),
                                    ),
                                    Text('data')
                                  ],
                                )),
                          );
                        },
                      ))),
            ),
          ],
        ));
  }
}
