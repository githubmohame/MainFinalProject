import 'package:final_project_year/bloc/select_muilt_type/cubit/select_muilt_type_cubit.dart';
import 'package:final_project_year/common_component/main_diwer.dart';
import 'package:final_project_year/main_screens/farm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSupplierScreen extends StatelessWidget {
  const AddSupplierScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: MainDrawer(index: 50),
        appBar:
            AppBar(backgroundColor: Colors.green, title: Text("اضافه عمال")),
        body: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                )),
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {},
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "رقم التليفون"),
                  keyboardType: TextInputType.phone,
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                )),
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {},
                  decoration:
                      InputDecoration(border: InputBorder.none, hintText: "كود المزرعة"),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                )),
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {},
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "الاسم"),
                  keyboardType: TextInputType.text,
                ),
              ),
               BlocProvider(
                create: (context) => SelectMuiltTypeCubit(list: []),
                child: Container(
                  child: CustomeType(title:  "اسم المنتج",
                    list: [
                      {"kill me": 1},
                      {"go to hell": 0}
                    ],
                  ),
                ),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.grey),
                    overlayColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.green)),
                onPressed: () {},
                child: Text(
                  "حفظ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}