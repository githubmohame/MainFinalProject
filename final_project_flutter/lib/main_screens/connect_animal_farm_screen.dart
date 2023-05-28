import 'package:dio/dio.dart';
import 'package:final_project_year/apis/apis_functions.dart';
import 'package:final_project_year/bloc/animals_selection/cubit/animal_cubit.dart';
import 'package:final_project_year/common_component/background.dart';
import 'package:final_project_year/common_component/custome_dropdownbutton.dart';
import 'package:final_project_year/common_component/custome_stackbar.dart';
import 'package:final_project_year/common_component/select_animal.dart';
import 'package:final_project_year/input_validation/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:final_project_year/common_component/main_diwer.dart';

class ConnectAnimalFarm extends StatelessWidget {
  ConnectAnimalFarm({Key? key}) : super(key: key);
  List<TextEditingController> list = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  CustomeCheckbox customeCheckbox = CustomeCheckbox(
    value: false,
    text: "انثي",
  );
  DateTime date = DateTime.now();
  SelectAnimalType animalType = SelectAnimalType(platoonApi: platoon_type_api,speciesApi:animal_species_api ,);
  bool delete = false;
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: MainDrawer(index: 13),
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                "اضافة حيوانات للمزرعة",
                style: TextStyle(color: Colors.white),
              )),
          body: SingleChildScrollView(
            child: Container(
              height: 700,
              child: Center(
                child: Card(
                  color: const Color(0xFF357515),
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    width: 700,
                    child: SingleChildScrollView(
                      child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: list[0],
                                validator: (value) {
                                  if (funcStringValidation(
                                          value: value.toString(),
                                          errorHeight: 0.0) ==
                                      0.0) {
                                    return null;
                                  }
                                  return 'the field is required';
                                },
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    hintText: "السجل التجاري"),
                                keyboardType: TextInputType.text,
                              ),
                              Container(
                                height: 10,
                              ),
                              TextFormField(
                                controller: list[1],
                                validator: (value) {
                                  if (delete) {
                                    return null;
                                  }
                                  if (funcNumValidation(
                                          value: value.toString(),
                                          errorHeight: 0.0) ==
                                      0) {
                                    return null;
                                  }
                                  return 'the number is not a number';
                                },
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    hintText: "عدد الحيوانات"),
                                keyboardType: TextInputType.number,
                              ),
                              Container(
                                height: 10,
                              ),
                              Container(
                                child: FutureBuilder(
                                    future: animal_api(),
                                    builder: (context, snap) {
                                      if (snap.data != null &&
                                          snap.data!.isNotEmpty) {
                                        print(snap.data);
                                         animalType = SelectAnimalType(platoonApi: platoon_type_api,speciesApi:animal_species_api ,
                                          platoon: snap.data![0]['platoon'],
                                        );

                                        return BlocProvider(
                                          create: (context) {
                                            //print(snap.data![0]['platoon']);
                                            //print(snap.data![0]['id']);
                                            animalType.platoon =
                                                snap.data![0]['platoon'];
                                            return AnimalCubit(
                                                platoon: snap.data![0]
                                                    ['platoon'],
                                                species: snap.data![0]['id']);
                                          },
                                          child: animalType,
                                        );
                                      }
                                      return Container();
                                    }),
                              ),
                              Container(
                                height: 0,
                              ),
                              /*TextFormField(
                            controller: list[3],
                            validator: (value) {
                              return null;
                            },
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                hintText: "التكلفة الكلية"),
                            keyboardType: TextInputType.number,
                          ),
                          Container(
                            height: 0,
                          ),*/
                              customeCheckbox,
                              ElevatedButton(
                                  onPressed: () async {
                                    date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1990),
                                            lastDate: DateTime(2050)) ??
                                        DateTime.now();
                                  },
                                  child: const Text('choose date')),
                              Container(
                                height: 10,
                              ),
                              Wrap(
                                children: [
                                  OutlinedButton(
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(200, 50)),
                                        shape: MaterialStateProperty
                                            .resolveWith((states) =>
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero)),
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.green),
                                        overlayColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.green)),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        int k = 0;
                                        //print(customeCheckbox.value);
                                        if (customeCheckbox.value) {
                                          k = 1;
                                        }
                                        //print(k);
                                        if (formKey.currentState!.validate()) {
                                          Map<String, dynamic> dic1 = {
                                            'operation': "insert",
                                            'species': animalType.platoon,
                                            "farm_id": list[0].text,
                                            'animal_number': list[1].text,
                                            'date': date,
                                            "is_male": k,
                                          };
                                         // print(animalType.platoon);
                                          FormData formData = FormData.fromMap(
                                              dic1, ListFormat.multi, false);
                                          var res = await add_farmer_animal_api(
                                              form: formData);
                                          if (res.containsKey('message')) {
                                            showSnackbardone(
                                                context: context,
                                                text: res['message']);
                                          } else {
                                            showSnackbarerror(
                                                context: context,
                                                text: res['error']);
                                          }
                                          return;
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "حفظ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                  ),
                                  OutlinedButton(
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(200, 50)),
                                        shape: MaterialStateProperty
                                            .resolveWith((states) =>
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero)),
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.red),
                                        overlayColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.red)),
                                    onPressed: () async {
                                      int k = 0;
                                     // print(customeCheckbox.value);
                                      if (customeCheckbox.value) {
                                        k = 1;
                                      }
                                      delete = true;
                                      if (formKey.currentState!.validate()) {
                                        Map<String, dynamic> dic1 = {
                                          'operation': "delete",
                                          'species': animalType.platoon,
                                          "farm_id": list[0].text,
                                          'animal_number': list[1].text,
                                          'date': date,
                                          "is_male": k,
                                        };
                                       // print(animalType.platoon);
                                        FormData formData = FormData.fromMap(
                                            dic1, ListFormat.multi, false);
                                        var res = await add_farmer_animal_api(
                                            form: formData);
                                        if (res.containsKey('message')) {
                                          showSnackbardone(
                                              context: context,
                                              text: res['message']);
                                        } else {
                                          showSnackbarerror(
                                              context: context,
                                              text: res['error']);
                                        }
                                        return;
                                      }
                                      delete = false;
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//class CustomeContainer extends Container {}

/*
 OutlinedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.grey),
                                        overlayColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.orange)),
                                    onPressed: () {},
                                    child: Text(
                                      "تعديل",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
*/
class CustomeCheckbox extends StatefulWidget {
  bool value;
  String text;
  CustomeCheckbox({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);
  @override
  State<CustomeCheckbox> createState() => _CustomeCheckboxState();
}

class _CustomeCheckboxState extends State<CustomeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.grey,
          fillColor:
              MaterialStateProperty.resolveWith((states) => Colors.white),
          value: widget.value,
          onChanged: (value) {
            setState(() {
              widget.value = value ?? false;
            });
          },
        ),
        Text(
          widget.text,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
