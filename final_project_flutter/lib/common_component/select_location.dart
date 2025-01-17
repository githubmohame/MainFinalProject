import 'package:final_project_year/apis/apis_functions.dart';
import 'package:final_project_year/bloc/location/cubit/choice_cubit.dart';
import 'package:final_project_year/common_component/custome_dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'show_load_screen.dart';

class SelectLocation extends StatelessWidget {
  int village;
  int city;
  SelectLocation({
    super.key,
    required this.village,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Api.location_api(),
        builder: (context, snapOuter) {
          if (snapOuter.data is List<Map<String, dynamic>> &&
              snapOuter.data!.isNotEmpty) {
            return SizedBox(
              height: 300,
              child: BlocProvider(
                create: (context) => LocationCubit(
                  city: snapOuter.data![0]['city'],
                  gavernorate: snapOuter.data![0]['governorate'],
                  village: snapOuter.data![0]['village'],
                ),
                child: Builder(builder: (context) {
                  city = snapOuter.data![0]['city'];
                  village = snapOuter.data![0]['village'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(5),
                          width: 500,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.white,
                          )),
                          child: FutureBuilder(
                              future: Api.gavernorate_api(),
                              builder: (context, snap) {
                                try {
                                  if (snap.connectionState ==
                                      ConnectionState.done) {
                                    return CustomeDropdownButton(
                                        id: 'id',
                                        func: (int value) {
                                          BlocProvider.of<LocationCubit>(
                                                  context)
                                              .updateGavernorate(value);
                                        },
                                        list: snap.data ??
                                            const [
                                              {"name": "اسيوط"},
                                              {"name": "القاهرة"},
                                              {"name": "المنةفية"}
                                            ],
                                        expanded: true,
                                        value: snapOuter.data![0]
                                                ['governorate'] ??
                                            -1,
                                        text: "المحافظة");
                                  }
                                } catch (e) {
                                  //
                                }

                                return Container();
                              })),
                      BlocBuilder<LocationCubit, LocationState>(
                        buildWhen: (previous, current) {
                          //
                          return previous.gavernorate != current.gavernorate;
                        },
                        builder: (context, state) {
                          return FutureBuilder(
                              future:
                                  Api.city_api(gavernorate: state.gavernorate),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                        ConnectionState.done &&
                                    snap.data is List<Map<String, dynamic>> &&
                                    snap.data!.isNotEmpty) {
                                  city = snap.data!.first['id'] ?? -1;

                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.white,
                                    )),
                                    child: CustomeDropdownButton(
                                        id: 'id',
                                        func: (int value) {
                                          BlocProvider.of<LocationCubit>(
                                                  context)
                                              .updateCity(value);
                                          city = value;
                                        },
                                        list: snap.data ??
                                            const [
                                              {"name": "اسيوط"},
                                              {"name": "القاهرة"},
                                              {"name": "المنةفية"}
                                            ],
                                        expanded: true,
                                        value: state.city ?? -1,
                                        text: "المركز او المدينة"),
                                  );
                                }
                                return const SizedBox(
                                  height: 0,
                                  width: 0,
                                );
                              });
                        },
                      ),
                      BlocBuilder<LocationCubit, LocationState>(
                        buildWhen: (previous, current) {
                          return previous.city != current.city;
                        },
                        builder: (context, state) {
                          return FutureBuilder(
                              future: Api.village_api(city: state.city),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                        ConnectionState.done &&
                                    snap.data is List<Map<String, dynamic>> &&
                                    snap.data!.isNotEmpty) {
                                  village = snap.data!.first['id'] ?? '';
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.white,
                                    )),
                                    child: CustomeDropdownButton(
                                        id: 'id',
                                        func: (int value) {
                                          BlocProvider.of<LocationCubit>(
                                                  context)
                                              .updateVillage(value);
                                          village = value;
                                        },
                                        list: snap.data ??
                                            const [
                                              {"name": "اسيوط"},
                                              {"name": "القاهرة"},
                                              {"name": "المنةفية"}
                                            ],
                                        expanded: true,
                                        value: state.village ?? -1,
                                        text: "القرية او الشارع"),
                                  );
                                }

                                return const SizedBox(
                                  height: 0,
                                  width: 0,
                                );
                              });
                        },
                      ),
                    ],
                  );
                }),
              ),
            );
          }
          return const LoadingScreen();
        });
  }
}

class SelectLocationDashBoard extends StatefulWidget {

  const SelectLocationDashBoard({
    super.key,
    //required this.village,
    //required this.city,
  });

  @override
  State<SelectLocationDashBoard> createState() => _SelectLocationDashBoardState();
}

class _SelectLocationDashBoardState extends State<SelectLocationDashBoard> with AutomaticKeepAliveClientMixin{
  int village = 0;

  int city = 0;

  int governorate = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Wrap(
        children: [
          Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.white,
              )),
              child: FutureBuilder(
                  future: Api.gavernorate_api(),
                  builder: (context, snap) {
                    try {
                      if (snap.connectionState == ConnectionState.done) {
                         (snap.data as List).add({"id": -1, "name": "__"});
                        return SizedBox(
                          child: BlocBuilder<LocationCubit, LocationState>(
                            builder: (context, state) {
                               return CustomeDropdownButton(
                                  color: const Color(0xffc79154),
                                  textColor: Colors.white,
                                  id: 'id',
                                  func: (int value) {
                                    BlocProvider.of<LocationCubit>(context)
                                        .updateGavernorate(value);
                                  },
                                  list: snap.data ??
                                      const [
                                        {"name": "اسيوط"},
                                        {"name": "القاهرة"},
                                        {"name": "المنةفية"}
                                      ],
                                  expanded: false,
                                  value: state.gavernorate,
                                  text: "المحافظة");
                            },
                          ),
                        );
                      }
                    } catch (e) {
                      //
                    }

                    return Container();
                  })),
          BlocBuilder<LocationCubit, LocationState>(
            buildWhen: (previous, current) {
              //
              return previous.gavernorate != current.gavernorate;
            },
            builder: (context, state) {
              return FutureBuilder(
                  future: Api.city_api(gavernorate: state.gavernorate),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done &&
                        snap.data is List<Map<String, dynamic>> &&
                        snap.data!.isNotEmpty) {
                      (snap.data as List).add({"id": -1, "name": "__"});
                      city = snap.data!.first['id'] ?? -1;

                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.white,
                        )),
                        child: CustomeDropdownButton(
                            color: const Color(0xffc79154),
                            textColor: Colors.white,
                            id: 'id',
                            func: (int value) {
                              BlocProvider.of<LocationCubit>(context)
                                  .updateCity(value);
                              city = value;
                            },
                            list: snap.data ??
                                const [
                                  {"name": "اسيوط"},
                                  {"name": "القاهرة"},
                                  {"name": "المنةفية"}
                                ],
                            expanded: false,
                            value: state.city,
                            text: "المركز او المدينة"),
                      );
                    }
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
