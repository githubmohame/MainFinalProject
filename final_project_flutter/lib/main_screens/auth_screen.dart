import 'package:final_project_year/common_component/background.dart';
import 'package:final_project_year/common_component/custome_dropdownbutton.dart';
import 'package:final_project_year/common_component/custome_secure_storage.dart';
import 'package:final_project_year/main_screens/farmer_list.dart';
import 'package:final_project_year/main_screens/list_farm.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key, required this.list});
  List<Map<String, dynamic>> list;
  CustomeDropDownButtonSelectAuth? customeDropDownButtonSelectAuth;
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BackgroundScreen(
          child: Scaffold(
            backgroundColor: Colors
                .transparent, //appBar: AppBar(title: Text('صفة الدخول'),),
            body: SafeArea(
                child: Center(
                    child: Container(
              height: 300,
              width: 300,
              child: Card(
                color: Colors.green.shade900,
                elevation: 12,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'صفة الدخول',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      Spacer(),
                      () {
                        customeDropDownButtonSelectAuth =
                            CustomeDropDownButtonSelectAuth(
                          id: "name",
                          func: (value) {},
                          expanded: true,
                          list: list,
                          text: "",
                          value: list[0]["name"],
                          color: Colors.green.shade500,
                          textColor: Colors.black,
                        );
                        return customeDropDownButtonSelectAuth!;
                      }(),
                      TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.blue)),
                          onPressed: () {
                            CustomeSecureStorage.setauth(
                                user_auth:
                                    customeDropDownButtonSelectAuth!.value);
                            if (customeDropDownButtonSelectAuth!.value ==
                                "farmer") {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return FarmList();
                                },
                              ));
                            }
                          },
                          child: Text("دخول",
                              style: TextStyle(color: Colors.white))),
                      Spacer(),
                    ]),
              ),
            ))),
          ),
        ));
  }
}
