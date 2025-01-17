// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:final_project_year/apis/apis_functions.dart';
import 'package:final_project_year/common_component/custome_secure_storage.dart';
import 'package:final_project_year/main_screens/auth_screen.dart';
import 'package:final_project_year/main_screens/list_farm.dart';
import 'package:flutter/material.dart';

import 'package:final_project_year/main_screens/add_admin_screen.dart';
import 'package:final_project_year/main_screens/add_animal.dart';
import 'package:final_project_year/main_screens/bash_board_screen.dart';
import 'package:final_project_year/main_screens/change_password_screen.dart';
import 'package:final_project_year/main_screens/connect_animal_farm_screen.dart';
import 'package:final_project_year/main_screens/connect_farm_farmer_screen.dart';
import 'package:final_project_year/main_screens/farm_screen.dart';
import 'package:final_project_year/main_screens/farmer_list.dart';
import 'package:final_project_year/main_screens/farmer_screen.dart';
import 'package:final_project_year/main_screens/login.dart';
import 'package:final_project_year/main_screens/screen_gavernorate.dart';


class MainDrawer extends StatefulWidget {
  int index;
  MainDrawer({
    super.key,
    required this.index,
  });
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  //>
  String auth = "";

  @override
  void initState() {
    // TODO: implement initState

    CustomeSecureStorage.getauth().then((value) {
      auth = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("killer "*551);
    return Drawer(
      backgroundColor: const Color(0xFF003e29),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //scrollDirection: Axis.vertical,
          children: [
            auth == "fockeltpoint"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        Container(
                          height: 100,
                          color: widget.index == 5
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 1,
                            leading: const Image(
                                image: AssetImage('assets/images/list.png')),
                            title: const Text("عرض المربين",
                                style: TextStyle(color: Colors.white)),
                            onTap: (() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListFarmer(),
                                  ));
                            }),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                          height: 100,
                          color: widget.index == 15
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 1,
                            title: const Text('عرض المزارع',
                                style: TextStyle(color: Colors.white)),
                            onTap: (() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FarmList(),
                                  ));
                            }),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                          height: 100,
                          color: widget.index == 0
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: ListTile(
                            leading: Image.asset('assets/images/field.png'),
                            title: const Text("اضافة مزرعة",
                                style: TextStyle(color: Colors.white)),
                            onTap: (() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FarmScreen(),
                                  ));
                            }),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                          height: 100,
                          color: widget.index == 2
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: Center(
                            child: Center(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                minVerticalPadding: 1,
                                leading: Image.asset('assets/images/farmer.png',
                                    height: 100, width: 50),
                                title: const Text("اضافة مربي",
                                    style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FarmerScreen(),
                                      ));
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                          height: 100,
                          color: widget.index == 3
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 1,
                              leading: Image.asset('assets/images/network.png'),
                              title: const Text("ربط المزرعة اضافة بالمربين",
                                  style: TextStyle(color: Colors.white)),
                              onTap: (() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ConnectFarmAndFarmerScreen(),
                                    ));
                              }),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Container(
                          height: 100,
                          color: widget.index == 13
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 1,
                            title: const Text('اضافة حيوانات للمزرعة',
                                style: TextStyle(color: Colors.white)),
                            onTap: (() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ConnectAnimalFarm(),
                                  ));
                            }),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                      ])
                : Container(),
            //
            auth == "supervisor"
                ? Column(
                    children: [
                      Container(
                        color: widget.index == 1
                            ? Colors.grey
                            : const Color(0xFF003e29),
                        height: 100,
                        child: Center(
                          child: ListTile(
                            horizontalTitleGap: 0,
                            leading: const Icon(Icons.home,
                                size: 35, color: Colors.white),
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            title: const Text("صفحة الترحيب",
                                style: TextStyle(color: Colors.white)),
                            onTap: (() {
                            //Navigator.of(context).history.forEach((element) {});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashBoardScreen(),
                                  ));
                            }),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ],
                  )
                : Container(),

            Container(
              height: 100,
              color: widget.index == 4 ? Colors.grey : const Color(0xFF003e29),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 1,
                leading: const Icon(Icons.person, size: 50, color: Colors.grey),
                title: const Text("تسجيل الدخول",
                    style: TextStyle(color: Colors.white)),
                onTap: (() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogIN(),
                      ));
                }),
              ),
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            auth == "admin"
                ? Column(children: [
                    Container(
                      height: 150,
                      color: widget.index == 6
                          ? Colors.grey
                          : const Color(0xFF003e29),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 1,
                        leading: const Icon(Icons.location_on),
                        title: const Text("اضافة او تعديل مكان",
                            style: TextStyle(color: Colors.white)),
                        onTap: (() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   AddLocationScreen(),
                              ));
                        }),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    Container(
                      height: 150,
                      color: widget.index == 7
                          ? Colors.grey
                          : const Color(0xFF003e29),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 1,
                        leading: const Icon(Icons.pets),
                        title: const Text("اضافة او تعديل حيوان",
                            style: TextStyle(color: Colors.white)),
                        onTap: (() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdateAnimal(),
                              ));
                        }),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    Container(
                      height: 150,
                      color: widget.index == 14
                          ? Colors.grey
                          : const Color(0xFF003e29),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 1,
                        title: const Text('اضافة   مودرين',
                            style: TextStyle(color: Colors.white)),
                        onTap: (() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddAdmin(),
                              ));
                        }),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                  ])
                : Container(),

            Container(
              height: 100,
              color: widget.index == 10 ? Colors.grey : const Color(0xFF003e29),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 1,
                leading: const Icon(Icons.password),
                title: const Text('تغير كلمة المرور',
                    style: TextStyle(color: Colors.white)),
                onTap: (() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ));
                }),
              ),
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),

            FutureBuilder(
                future: CustomeSecureStorage.getauthCount(),
                builder: (context, snap) {
                 
                  if (snap.data!=null&&snap.data! > 1) {
                     print(snap.data);
                    return Column(
                      children: [
                        Container(
                          width: 400,
                          height: 30,
                          color: widget.index == 15
                              ? Colors.grey
                              : const Color(0xFF003e29),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 1,
                            title: const Text('تغير صفة الدخول',
                                style: TextStyle(color: Colors.white)),
                            onTap: (() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FutureBuilder(
                                        future: Api.user_athority(),
                                        builder: (context, snap) {
                                          if (snap.data != null) {
                                            return AuthScreen(
                                              list: snap.data!,
                                            );
                                          }
                                          return Container();
                                        }),
                                  ));
                            }),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                          width: 1,
                        ),
                      ],
                    );
                  }

                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}

//
class ComputerDrawer extends StatelessWidget {
  int index;
  ComputerDrawer({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF003e29),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            height: 1,
            color: Colors.black,
          ),
          Container(
            width: 400,
            height: 100,
            color: index == 0 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              leading: Image.asset('assets/images/field.png'),
              title: const Text("اضافة مزرعة",
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FarmScreen(),
                    ));
              }),
            ),
          ),
          Container(height: 1, color: Colors.black, width: 1),
          Container(
            width: 400,
            color: index == 1 ? Colors.grey : const Color(0xFF003e29),
            height: 100,
            child: Center(
              child: ListTile(
                horizontalTitleGap: 0,
                leading: const Icon(Icons.home, size: 35, color: Colors.white),
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                title: const Text("صفحة الترحيب",
                    style: TextStyle(color: Colors.white)),
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashBoardScreen(),
                      ));
                }),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            height: 100,
            color: index == 2 ? Colors.grey : const Color(0xFF003e29),
            child: Center(
              child: Center(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 1,
                  leading: Image.asset('assets/images/farmer.png',
                      height: 100, width: 50),
                  title: const Text("اضافة مربي",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerScreen(),
                        ));
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            height: 100,
            color: index == 3 ? Colors.grey : const Color(0xFF003e29),
            child: Center(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 1,
                leading: Image.asset('assets/images/network.png'),
                title: const Text("ربط المزرعة اضافة بالمربين",
                    style: TextStyle(color: Colors.white)),
                onTap: (() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ConnectFarmAndFarmerScreen(),
                      ));
                }),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            height: 100,
            color: index == 4 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              leading: const Icon(Icons.person, size: 50, color: Colors.grey),
              title: const Text("تسجيل الدخول",
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogIN(),
                    ));
              }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            height: 150,
            color: index == 5 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              leading: const Image(image: AssetImage('assets/images/list.png')),
              title: const Text("عرض المربين",
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListFarmer(),
                    ));
              }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            height: 150,
            color: index == 6 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              leading: const Icon(Icons.location_on),
              title: const Text("اضافة او تعديل مكان",
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>   AddLocationScreen(),
                    ));
              }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            height: 150,
            color: index == 7 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              leading: const Icon(Icons.pets),
              title: const Text("اضافة او تعديل حيوان",
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateAnimal(),
                    ));
              }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          /*
          Container(
            width: 400,
            //height: 10,
            color: index == 8 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              leading: const Image(
                  image: AssetImage('assets/images/drawer_statistics.png')),
              title: const Text("االاحصائيات",
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChartScreen(),
                    ));
              }),
            ),
          ),*/
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 10 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              leading: const Icon(Icons.password),
              title: const Text('تسجيل كلمة المرور',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ));
              }),
            ),
          ),
          /* Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 11 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              title: const Text('اضافة عمال',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Worker_Screen(),
                    ));
              }),
            ),
          ),*/
          /*Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 12 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              title: const Text('اضافة مواردين',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAdmin(),
                    ));
              }),
            ),
          ),*/
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 13 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              title: const Text('اضافة حيوانات للمزرعة',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectAnimalFarm(),
                    ));
              }),
            ),
          ),
          /*Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 14 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              title: const Text('ربط المزرعة بالعمال',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenConnectFarmWorkers(),
                    ));
              }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 15 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              title: const Text('ربط المزرعة بالموردين',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectSuppliersFarmer(),
                    ));
              }),
            ),
          ),*/
          //AddAdmin
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          Container(
            width: 400,
            //height: 10,
            color: index == 14 ? Colors.grey : const Color(0xFF003e29),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 1,
              title: const Text('اضافة مودرين',
                  style: TextStyle(color: Colors.white)),
              onTap: (() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAdmin(),
                    ));
              }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            width: 1,
          ),
          FutureBuilder(
              future: CustomeSecureStorage.getauthCount(),
              builder: (context, snap) {
                print("hell" * 765);
                print(snap.data);
                if (snap.data! > 1) {
                  return Column(
                    children: [
                      Container(
                        width: 400,
                        height: 30,
                        color:
                            index == 15 ? Colors.grey : const Color(0xFF003e29),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 1,
                          title: const Text('عرض المزارع',
                              style: TextStyle(color: Colors.white)),
                          onTap: (() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthScreen(list: const []),
                                ));
                          }),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.black,
                        width: 1,
                      ),
                    ],
                  );
                }
                return Container();
              })
          //
        ],
      ),
    );
  }
}

class CustomeDrawerView2 extends StatefulWidget {
  const CustomeDrawerView2({super.key});

  @override
  State<CustomeDrawerView2> createState() => _CustomeDrawerView2State();
}

class _CustomeDrawerView2State extends State<CustomeDrawerView2> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                Container(
                  height: 50,
                ),
                const Row(
                  children: [
                    Spacer(),
                    Icon(
                      Icons.play_arrow_rounded,
                      weight: 12,
                      size: 70,
                      color: Color(0XFF48ad69),
                    ),
                    Text(
                      'DashBoard',
                      style: TextStyle(
                          color: Color(0xff5d5d5d),
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                  ],
                ),
                Container(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FarmerScreen();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.qr_code_2_outlined,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'اضافة مربين',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const FarmScreen();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'اضافة مزرعة',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const ConnectFarmAndFarmerScreen();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.store_outlined,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'ربط المزرعه بالمربين',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return   AddLocationScreen();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'تعديل مكان',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const UpdateAnimal();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'تعديل حيوان',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const AddAdmin();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/pie-chart.png'),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'اضافة مودرين',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ChangePasswordScreen();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.qr_code_2_outlined,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'تغير كلمة المرور',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ListFarmer();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.qr_code_2_outlined,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'عرض مربين',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ListFarmer();
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.qr_code_2_outlined,
                          color: Color(0xFF5f6271),
                        ),
                        Container(
                          width: 10,
                        ),
                        const Text(
                          'عرض المزرعة',
                          style: TextStyle(color: Color(0xff6f766f)),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract class A {
  int u;
  A({
    required this.u,
  });

  int sq({int u = 90});
}

class B extends A {
  @override
  int u;

  B({required super.u, required int m}) : u = m;

  @override
  int sq({int sq1 = 90, u = 89}) {
    return 0;
  }
}
