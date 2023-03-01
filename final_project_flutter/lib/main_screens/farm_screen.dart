// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:final_project_year/common_component/custome_text_field.dart';
import 'package:final_project_year/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:final_project_year/api_function.dart/app_api.dart';
import 'package:final_project_year/bloc/location/cubit/choice_cubit.dart';
import 'package:final_project_year/bloc/select_muilt_type/cubit/select_muilt_type_cubit.dart';
import 'package:final_project_year/common_component/background.dart';
import 'package:final_project_year/common_component/main_diwer.dart';

class CustomeDropdownButton extends StatefulWidget {
  String value;
  String text;
  bool expanded = false;
  List<Map<String, String>> list;
  void Function(String value)? func;
  CustomeDropdownButton({
    Key? key,
    this.func,
    required this.value,
    required this.text,
    required this.expanded,
    required this.list,
  }) : super(key: key);

  @override
  State<CustomeDropdownButton> createState() => _CustomeDropdownButtonState();
}

class _CustomeDropdownButtonState extends State<CustomeDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        builder: (context, snapshot) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.text),
              ],
            ),
            DropdownButton<String>(
              style: TextStyle(color: Colors.brown),
              isExpanded: widget.expanded,
              underline: Container(),
              focusColor: Colors.white,
              alignment: Alignment.bottomLeft,
              value: widget.value,
              items: List.generate(widget.list.length, (index) {
                return DropdownMenuItem(
                    value: widget.list[index]["name"],
                    child: Text(
                      widget.list[index]["name"].toString(),
                    ));
              }),
              onChanged: (value) {
                print(value);
                setState(() {
                  widget.value = value ?? widget.list[0]['name']!;

                  if (widget.func is Function(String value)) {
                    widget.func!(widget.value);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> f1() {
  return Future<List>.delayed(const Duration(seconds: 10)).then((value) => [
        {"kill": 'see'}
      ]);
}

class FarmScreen extends StatefulWidget {
  FarmScreen({Key? key}) : super(key: key);

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  FarmType farmType = FarmType();

  SectionType sectionType = SectionType();

  List<TextEditingController> controller =
      List.generate(9, (index) => TextEditingController());

  final _formGlobalKey = GlobalKey<FormState>();

  double errorHeight = 0;

  SelectLocation selectLocation = SelectLocation(
    village: '',
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundScreen(
        child: LayoutBuilder(builder: (context, constraint) {
          //print(constraint.maxWidth);
          return Scaffold(
            appBar: constraint.maxWidth < 900
                ? AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      "اضافه المزرعة",
                      style: TextStyle(color: Colors.white),
                    ))
                : null,
            backgroundColor: Colors.red.withOpacity(0),
            drawer: constraint.maxWidth < 900 ? MainDrawer(index: 0) : null,
            body: SingleChildScrollView(
              child: Container(
                height: 1600 + 178 + 150 + 52 + 70 + 50 + 25 + errorHeight,
                child: Container(
                  child: Column(
                    children: [
                      constraint.maxWidth > 900
                          ? Container(
                              height: 100, child: ComputerDrawer(index: 0))
                          : Container(),
                      Container(height: 20),
                      Card(
                        elevation: 30,
                        color: Color(0xFF357515),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          height:
                              1780 + 52  + 30 +  25 + errorHeight,
                          width: 700,
                          child: Form(
                              key: _formGlobalKey,
                              child: Column(
                                children: [
                                  constraint.maxWidth > 900
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                color: Colors.transparent,
                                              )),
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                "اضافة مزرعة",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          'رقم السجل الضريبي',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField(inputFormatters:  [FilteringTextInputFormatter.allow(
                                          RegExp(r'[ا-ي0-9]'))],
                                    controller: controller[0],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());

                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          'عدد عمال المزرعة',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField(inputFormatters:  [FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))],
                                    controller: controller[1],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());
                                      if (s1.isNotEmpty) {

                                        errorHeight += 10;
                                        return s1;
                                      }
                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);
                                      if (s1.isEmpty) {
                                        return null;
                                      }
                                      errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          'المساحة الكلية للمزرعة',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField(inputFormatters:  [FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))],
                                    controller: controller[2],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());
                                      if (s1.isNotEmpty) {

                                        errorHeight += 10;
                                        return s1;
                                      }
                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);
                                      if (s1.isEmpty) {
                                        return null;
                                      }
                                         errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          'ادخل اسم المزرعة',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField( inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[ا-ي ]{1,}[0-8]{0,8}'))
                                    ],
                                    controller: controller[3],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());
                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }
                                      if (s1.isNotEmpty) {
                                        return s1;
                                      }
                                      if (s1.isEmpty) {
                                        return null;
                                      }

                                        errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.text,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          "اعدد الملاعب",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField( inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    controller: controller[4],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());
                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }
 
                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);

                                      if (s1.isEmpty) {
                                        return null;
                                      }

                                        errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          "سعة الملاعب",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField( inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    controller: controller[5],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());
                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }

                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);
                                      if (s1.isEmpty) {
                                        return null;
                                      }

                                        errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          "اعدد العنابر",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField( inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    controller: controller[6],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());

                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }

                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);
                                      if (s1.isEmpty) {
                                        return null;
                                      }

                                        errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          'عدد عنابر العزل',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField( inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    controller: controller[7],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());

                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }

                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);
                                      if (s1.isEmpty) {
                                        return null;
                                      }

                                        errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                          "ادخل عدد الافدنة الملحقة",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomeTextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    controller: controller[8],
                                    validator: (value) {
                                      String s1 = isEmpty(s1: value.toString());

                                      if (s1.isNotEmpty) {
                                        errorHeight += 10;
                                        return s1;
                                      }

                                      s1 += biggerMin(
                                          s1: value.toString(), min: 0);
                                      if (s1.isEmpty) {
                                        return null;
                                      }

                                        errorHeight += 10;
                                      return s1;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  sectionType,
                                  Container(
                                      height: 319,
                                      margin: EdgeInsets.all(10),
                                      child: GoogleMapComponent()),
                                  Container(
                                    height: 260,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: BlocProvider(
                                          create: (context) => LocationCubit(
                                              city: 'مركز دكرنس',
                                              gavernorate: 'الدقهلية',
                                              village: 'الجزيره'),
                                          child: Builder(builder: (context) {
                                            selectLocation.village =
                                                selectLocation == ''
                                                    ? 'الجزيره'
                                                    : selectLocation.village;
                                            return selectLocation;
                                          }),
                                        )),
                                      ],
                                    ),
                                  ),
                                  farmType,
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size(200, 50)),
                                            shape: MaterialStateProperty.resolveWith(
                                                (states) =>
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30))),
                                            backgroundColor:
                                                MaterialStateProperty.resolveWith(
                                                    (states) => Colors.green),
                                            overlayColor:
                                                MaterialStateProperty.resolveWith(
                                                    (states) => Colors.green)),
                                        onPressed: () {
                                          if (_formGlobalKey.currentState!
                                              .validate()) {
                                            print(farmType
                                                .customeFarmType.item_choose);
                                            print(sectionType
                                                .customeDropdownButtonSectionType
                                                .value);
                                            print(selectLocation.village);
                                            for (TextEditingController i
                                                in controller) {
                                              print(i.text);
                                            }
                                          }
                                        setState(() {
                                          
                                        });
                                        },
                                        child: const Text(
                                          "حفظ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      OutlinedButton(
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size(200, 50)),
                                            shape: MaterialStateProperty.resolveWith(
                                                (states) =>
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30))),
                                            backgroundColor:
                                                MaterialStateProperty.resolveWith(
                                                    (states) => Colors.red),
                                            overlayColor:
                                                MaterialStateProperty.resolveWith(
                                                    (states) => Colors.red)),
                                        onPressed: () {
                                          print(farmType.customeFarmType.list);
                                        },
                                        child: const Text(
                                          "حذف",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FarmType extends StatelessWidget {
  CustomeType customeFarmType = CustomeType(title: "نوع المزرعة", list: []);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: farm_type_api(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            customeFarmType =
                CustomeType(title: "نوع المزرعة", list: snap.data ?? []);
            return BlocProvider(
              create: (context) => SelectMuiltTypeCubit(list: []),
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(10),
                child: customeFarmType,
              ),
            );
          }
          return Container();
        });
  }
}

class SectionType extends StatelessWidget {
  SectionType({super.key});
  CustomeDropdownButton customeDropdownButtonSectionType =
      CustomeDropdownButton(
    list: const [
      {"name": "عام"},
      {"name": "خاص"}
    ],
    expanded: true,
    text: "نوع القطاع",
    value: 'خاص',
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(10),
      child: FutureBuilder(
          future: section_type_api(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              customeDropdownButtonSectionType = CustomeDropdownButton(
                list: snap.data ??
                    const [
                      {"name": "عام"},
                      {"name": "خاص"}
                    ],
                expanded: true,
                text: "نوع القطاع",
                value: 'خاص',
              );
              return customeDropdownButtonSectionType;
            }
            return Container();
          }),
    );
  }
}

class SelectLocation extends StatelessWidget {
  String village;
  SelectLocation({
    Key? key,
    required this.village,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('build');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white,
            )),
            child: FutureBuilder(
                future: gavernorate_api(),
                builder: (context, snap) {
                  try {
                    if (snap.connectionState == ConnectionState.done) {
                      return CustomeDropdownButton(
                          func: (String value) {
                            BlocProvider.of<LocationCubit>(context)
                                .updateGavernorate(value);
                          },
                          list: snap.data ??
                              const [
                                {"name": "اسيوط"},
                                {"name": "القاهرة"},
                                {"name": "المنةفية"}
                              ],
                          expanded: true,
                          value: snap.data!.first['name'] ?? 'اسيوط',
                          text: "المحافظة");
                    }
                  } catch (e) {}

                  return Container();
                })),
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.white,
          )),
          child: BlocBuilder<LocationCubit, LocationState>(
            buildWhen: (previous, current) {
              //
              print(previous.gavernorate != current.gavernorate);
              return previous.gavernorate != current.gavernorate;
            },
            builder: (context, state) {
              print('build');
              return FutureBuilder(
                  future: city_api(gavernorate: state.gavernorate),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      return CustomeDropdownButton(
                          func: (String value) {
                            BlocProvider.of<LocationCubit>(context)
                                .updateCity(value);
                          },
                          list: snap.data ??
                              const [
                                {"name": "اسيوط"},
                                {"name": "القاهرة"},
                                {"name": "المنةفية"}
                              ],
                          expanded: true,
                          value: snap.data!.first['name'] ?? 'اسيوط',
                          text: "المركز او المدينة");
                    }
                    return Container();
                  });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.white,
          )),
          child: BlocBuilder<LocationCubit, LocationState>(
            buildWhen: (previous, current) {
              print(previous.city != current.city);
              return previous.city != current.city;
            },
            builder: (context, state) {
              print('build village');
              return FutureBuilder(
                  future: village_api(city: state.city),
                  builder: (context, snap) {
                    print(snap.data);
                    if (snap.connectionState == ConnectionState.done)
                      return CustomeDropdownButton(
                          func: (String value) {
                            BlocProvider.of<LocationCubit>(context)
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
                          value: snap.data!.first['name'] ?? 'اسيوط',
                          text: "القرية او الشارع");
                    return Container();
                  });
            },
          ),
        ),
      ],
    );
  }
}

class CustomeType extends StatefulWidget {
  List<Map<String, dynamic>> list;
  String title;
  bool visiable = false;
  List<String> item_choose = [];
  _CustomeTypeState state = _CustomeTypeState();
  CustomeType({Key? key, required this.list, required this.title})
      : super(key: key);
  @override
  State<CustomeType> createState() {
    return _CustomeTypeState();
  }
}

class _CustomeTypeState extends State<CustomeType> {
  _CustomeTypeState();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white,
            )),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white),
                      overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white)),
                  onPressed: () {
                    widget.visiable = !widget.visiable;
                    setState(() {});
                  },
                  icon: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                        textDirection: TextDirection.rtl,
                        size: 24,
                      )),
                  label: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(widget.title,
                          style: const TextStyle(color: Colors.black)))),
            )),
        Visibility(
          visible: widget.visiable,
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white),
              right: BorderSide(color: Colors.white),
              left: BorderSide(color: Colors.white),
            )),
            height: 50,
            child: BlocBuilder<SelectMuiltTypeCubit, SelectMuiltTypeState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    List<int> list = state.list;
                    widget.item_choose = List.generate(list.length, (index) {
                      return widget.list[index]['name'];
                    });
                    CustomeButton d;
                    if (list.contains(index)) {
                      d = CustomeButton(
                        customeColor: Colors.grey,
                        f: (bool click) {
                          if (click) {
                            BlocProvider.of<SelectMuiltTypeCubit>(context)
                                .addToList(index);
                          } else {
                            BlocProvider.of<SelectMuiltTypeCubit>(context)
                                .removeToList(index);
                          }
                        },
                        click: true,
                        text: widget.list[index].values.toList()[0],
                      );
                    } else {
                      d = CustomeButton(
                        customeColor: Colors.white,
                        f: (bool click) {
                          if (click) {
                            BlocProvider.of<SelectMuiltTypeCubit>(context)
                                .addToList(index);
                          } else {
                            BlocProvider.of<SelectMuiltTypeCubit>(context)
                                .removeToList(index);
                          }
                        },
                        click: false,
                        text: widget.list[index].values.toList()[0],
                      );
                    }
                    return d;
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomeButton extends StatefulWidget {
  String text;
  bool click;
  Function f;
  Color customeColor;
  CustomeButton({
    Key? key,
    required this.text,
    required this.customeColor,
    required this.click,
    required this.f,
  }) : super(key: key);

  @override
  State<CustomeButton> createState() => _CustomeButtonState();
}

class _CustomeButtonState extends State<CustomeButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: const BorderSide(color: Colors.grey))),
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => widget.click ? widget.customeColor : null)),
      onPressed: () {
        widget.click = !widget.click;
        widget.f(widget.click);
        setState(() {});
      },
      child: Text(widget.text, style: const TextStyle(color: Colors.black)),
    );
  }
}

class GoogleMapComponent extends StatefulWidget {
  const GoogleMapComponent({super.key});

  @override
  State<GoogleMapComponent> createState() => _GoogleMapComponentState();
}

class _GoogleMapComponentState extends State<GoogleMapComponent> {
  LatLng point = LatLng(0, 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xFF857e7b))),
                child: Text(
                  'ادخال الاحداثيات',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
            Spacer(),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xFF857e7b))),
                child: Text(
                  'اخذ الاحداث اللحالي',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Position p = await _determinePosition();
                  this.point = LatLng(p.latitude, p.longitude);
                  setState(() {});
                },
              ),
            ),
            Spacer(),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xFF857e7b))),
                child: Text(
                  'تحميل ملف سيغه shape file',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'shp',
                      '.shpx',
                    ],
                  );
                },
              ),
            )
          ],
        ),
        Container(
          height: 300 - 32,
          child: FlutterMap(
            options: MapOptions(
              onTap: (tapPosition, point) {
                this.point = point;
                setState(() {});
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                      height: 200,
                      width: 200,
                      point: point,
                      builder: (context) => Icon(Icons.location_on))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
