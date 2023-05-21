// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:final_project_year/common_component/background.dart';
import 'package:final_project_year/main_screens/bash_board_screen.dart';
import 'package:flutter/material.dart';

import '../common_component/main_diwer.dart';

class FarmList extends StatefulWidget {
  const FarmList({super.key});

  @override
  State<FarmList> createState() => _FarmListState();
}

class _FarmListState extends State<FarmList> {
  @override
  Widget build(BuildContext context) {
   return Directionality(
        textDirection: TextDirection.rtl,
        child: BackgroundScreen(
          child: Scaffold(
              drawer: MainDrawer(index: 8),
              appBar: AppBar(
                title: const Center(
                  child: Text('عرض المربين',style: TextStyle(color: Colors.white),),
                ),
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              body: LayoutBuilder(builder: (context, constraint) {
                print(constraint.maxWidth);
                return Row(children: [

                  constraint.maxWidth >= 1000 ? const Spacer() : Container(),
                  Expanded(
                    child: Container(
                      width: 400,
                      color: const Color(0xFF357515

),
                      child: Card(
                        color: const Color(0xFF357515

),
                        elevation: 20,
                        child: Column(
                          children: [
                            CustomeSearch(width: double.infinity,text:'ادخل اسم المربي' ),
                            Expanded(
                              child: ListView.separated(
        itemBuilder: (context, index) {
          return FarmItem(
            city: 'ttrrre',
            governorate: 'rree2234',
            village: 'rrffgdf',
            farmName: 'farm34556',
            id: '3345664',
            workers: 8,
            sectionType: 'خاص',
          );
        },
        separatorBuilder: (context, index) {
          return Container(height: 20,);
        },
        itemCount: 100),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  constraint.maxWidth >= 1000 ? const Spacer() : Container(),
                ]);
              })),
        ));
  }
}

class FarmItem extends StatelessWidget {
  String farmName, village, city, governorate, sectionType, id;
  int workers;
  FarmItem({
    Key? key,
    required this.farmName,
    required this.village,
    required this.city,
    required this.governorate,
    required this.sectionType,
    required this.id,
    required this.workers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card( elevation: 5,
          surfaceTintColor: const Color(0xFF467061),
      child: Column(
        children: [
          Row(
            children: [const Text('كود المزرعة'":"), Text(id)],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [const Text('اسم المزرعة'":",style: TextStyle(fontSize: 18,color: Colors.black),), Text(farmName)],
          ),const SizedBox(height: 5,),
          Row(
            children: [
               const Icon(Icons.location_on),
              Text("$village>",style: const TextStyle(fontSize: 18,color: Colors.black),),
              Text("$city>",style: const TextStyle(fontSize: 18,color: Colors.black),),
              Text(governorate,style: const TextStyle(fontSize: 18,color: Colors.black),)
            ],
          ),const SizedBox(height: 5,),
          Row(
            children: [const Text('عدد العمال'":",style: TextStyle(fontSize: 18,color: Colors.black),), Text(workers.toString(),style: const TextStyle(fontSize: 18,color: Colors.black),),],
          ),const SizedBox(height: 5,),
          Row(
            children: [const Text(':نوع القطاع',style: TextStyle(fontSize: 18,color: Colors.black),), Text(sectionType.toString(),style: const TextStyle(fontSize: 18,color: Colors.black),)],
          ),
        ],
      ),
    );
  }
}
