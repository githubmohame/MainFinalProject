// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:final_project_year/bloc/choice/cubit/choice_cubit.dart';
import 'package:final_project_year/common_component/background.dart';
import 'package:final_project_year/common_component/main_diwer.dart';
import 'package:final_project_year/main_screens/farm_screen.dart';

class ScreenGavernorate extends StatelessWidget {
  const ScreenGavernorate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Center(
        child: Container(
          width: 500,
          child: SingleChildScrollView(
            child: Card(
              color: Color(0xFF467061),
              elevation: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('تعديل في المحافظات',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Container(
                    child: BlocProvider(
                      create: (context) =>
                          ChoiceCubit(city: 0, gavernorate: 0, village: 0),
                      child: SelectGavernorate(title: 'المحافظة',list: const [
              {"id": 0, "name": "اسيوط"},
              {"id": 1, "name": "القاهرة"},
              {"id": 2, "name": "المنةفية"}
            ],),
                    ),
                  ),
                  const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "تعديل الاسم",
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.brown, width: 5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.brown, width: 2)),
                          focusColor: Colors.brown,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.brown, width: 2)))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(200, 50)),
                            shape: MaterialStateProperty.resolveWith((states) =>
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey),
                            overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.red)),
                        onPressed: () {},
                        child: const Text(
                          "مسح",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(200, 50)),
                            shape: MaterialStateProperty.resolveWith((states) =>
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey),
                            overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.brown)),
                        onPressed: () {},
                        child: const Text(
                          "حفظ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class SelectGavernorate extends StatefulWidget {
  String? village;
  String title;
  List<Map<String,dynamic>> list;
    SelectGavernorate({
    Key? key,
    this.village,
    required this.title,
    required this.list,
  }) : super(key: key);
   
  @override
  State<SelectGavernorate> createState() => _SelectGavernorateState();
}

class _SelectGavernorateState extends State<SelectGavernorate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomeDropdownButton(
            func: (int value) {
              BlocProvider.of<ChoiceCubit>(context).updateGavernorate(value);
            },
            list:  widget.list,
            expanded: true,
            value: 0,
            text: widget.title),
      ],
    );
  }
}

class SelectCity extends StatefulWidget {
  List<Map<String, dynamic>> list;
  List<Map<String, dynamic>> list2;
  String? village;
  List<String> titles;
    SelectCity({
    Key? key,
    required this.list,
    required this.list2,
    this.village,
    required this.titles,
  }) : super(key: key);
   
  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.grey,
            )),
            child: CustomeDropdownButton(
                func: (int value) {
                  BlocProvider.of<ChoiceCubit>(context).updateCity(value);
                },
                list: widget.list2,
                expanded: true,
                value: 0,
                text: widget.titles[0])),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.grey,
          )),
          child: BlocBuilder<ChoiceCubit, ChoiceState>(
            buildWhen: (previous, current) {
              //
              return previous.gavernorate != current.gavernorate;
            },
            builder: (context, state) {
              return CustomeDropdownButton(
                  func: (int value) {
                    BlocProvider.of<ChoiceCubit>(context).updateCity(value);
                  },
                  list: widget.list,
                  expanded: true,
                  value: 0,
                  text: widget.titles[1]);
            },
          ),
        ),
      ],
    );
  }
}

class ScreenCity extends StatelessWidget {
  const ScreenCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Card(
            color: Color(0xFF467061),
            elevation: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('تعديل في المحافظات',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                BlocProvider(
                  create: (context) =>
                      ChoiceCubit(city: 0, gavernorate: 0, village: 0),
                  child: SelectCity(list2:const [
                  {"id": 1, "name": "القاهرة"},
                  {"id": 0, "name": "القاهرة"}
                ], 
                    titles: const ['المحافظة', 'المركز'],
                    list: const [
                      {"id": 0, "name": "اسيوط"},
                      {"id": 1, "name": "القاهرة"},
                      {"id": 2, "name": "المنةفية"}
                    ],
                  ),
                ),
                const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "تعديل الاسم",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown, width: 5)),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(200, 50)),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.grey),
                          overlayColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.red)),
                      onPressed: () {},
                      child: const Text(
                        "مسح",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(200, 50)),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.grey),
                          overlayColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.brown)),
                      onPressed: () {},
                      child: const Text(
                        "حفظ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenVillage extends StatelessWidget {
  const ScreenVillage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Color(0xFF467061),
        elevation: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('تعديل في المحافظات',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            BlocProvider(
              create: (context) =>
                  ChoiceCubit(city: 0, gavernorate: 0, village: 0),
              child: SelectLocation(),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "تعديل الاسم",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown, width: 5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown, width: 2)),
                      focusColor: Colors.brown,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown, width: 2)))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.grey),
                      overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.red)),
                  onPressed: () {},
                  child: const Text(
                    "مسح",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.grey),
                      overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.brown)),
                  onPressed: () {},
                  child: const Text(
                    "حفظ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateLocation extends StatefulWidget {
  UpdateLocation({Key? key}) : super(key: key);

  @override
  State<UpdateLocation> createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  List<Widget> list = [
    const ScreenGavernorate(),
    const ScreenCity(),
    const ScreenVillage()
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundScreen(
        child: LayoutBuilder(builder: (context, constraint) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor:
                    Color.fromARGB(255, 202, 197, 197).withOpacity(0.5),
                currentIndex: index,
                unselectedFontSize: 15,
                showUnselectedLabels: true,
                selectedFontSize: 20,
                onTap: (value) {
                  setState(() {
                    index = value;
                  }); //
                },
                unselectedItemColor: Colors.white,
                selectedItemColor: Colors.white,
                selectedLabelStyle:
                    const TextStyle(color: Colors.white, fontSize: 20),
                items: const [
                  BottomNavigationBarItem(
                    label: 'تعديل المحافظة',
                    icon: Image(
                        image: AssetImage('assets/images/gavernorate.png')),
                  ),
                  BottomNavigationBarItem(
                    label: 'تعديل المركز او المدينة',
                    icon: Image(image: AssetImage('assets/images/city.png')),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    label: 'تعديل القرية والشارع',
                    icon: Image(image: AssetImage('assets/images/village.png')),
                  ),
                ]),
            backgroundColor: Colors.transparent,
            appBar: constraint.maxWidth < 900
                ? AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      'تعديل الاماكن',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : null,
            drawer: MainDrawer(index: 6),
            body: Column(
              children: [
                constraint.maxWidth > 900
                    ? Container(height: 100, child: ComputerDrawer(index: 6))
                    : Container(),
                Spacer(),
                list[index],
                Spacer(),
              ],
            ),
          );
        }),
      ),
    );
  }
}