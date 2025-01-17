import 'package:final_project_year/apis/apis_functions.dart';
import 'package:final_project_year/common_component/custome_secure_storage.dart';
import 'package:final_project_year/main_screens/login.dart';
import 'package:flutter/material.dart';

class CustomeDropdownButtomSignUp extends StatefulWidget {
  int value;
  CustomeDropdownButtomSignUp({
    super.key,
    required this.value,
  });
  @override
  State<CustomeDropdownButtomSignUp> createState() =>
      _CustomeDropdownButtomSignUpState();
}

class _CustomeDropdownButtomSignUpState
    extends State<CustomeDropdownButtomSignUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: DropdownButton(
        isDense: true,
        isExpanded: true,
        underline: Container(),
        value: widget.value,
        items: [
          const DropdownMenuItem<int>(
            value: 13,
            child: Row(
              children: [
                Expanded(child: Icon(Icons.person_2_rounded)),
                Expanded(
                    child: Text(
                  'SignOut',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )),
              ],
            ),
          ),
          DropdownMenuItem<int>(
            value: 12,
            child: Row(
              children: [
                FutureBuilder(
                    future: CustomeSecureStorage.getssn(),
                    builder: (context, snapout) {
                      return FutureBuilder(
                          future:
                              Api.image_farmer_api(ssn: snapout.data.toString()),
                          builder: (context, snap) {
                            if (snap.data is ImageProvider) {
                              return Expanded(
                                  child: Image(
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                                image: snap.data!,
                              ));
                            }
                            return Container();
                          });
                    }),
                const Expanded(
                    child: Text(
                  'Mohamed',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (value == 13) {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const LogIN();
              },
            ));
          }
        },
      ),
    );
  }
}
