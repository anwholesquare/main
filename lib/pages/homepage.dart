// ignore_for_file: prefer_const_constructors
import 'package:app/main.dart';
import 'package:app/style.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/widgets/promise_card_widget.dart';
import 'package:app/model/promise.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime queryDate = DateTime.now();
  String date = DateFormat.yMMMd().format(DateTime.now());
  bool isDark = firstThemeMode == ThemeMode.dark ? true : false;

  @override
  void initState() {
    super.initState();
  }
  
  void getThemeText() async {
    setState((){
      isDark = !isDark;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Stack(
            children:[ 
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                   appName,
                                    style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600,
                                    )
                              ),
                              GestureDetector(
                                onTap: () {
                                  MainApp.of(context).toggleThemeMode(context);
                                  getThemeText();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  child: Text(isDark ? "Dark" : "Light", textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                            
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text ("Hello! I assist you achieve your goals by keeping track of your promises and progress ✅"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:20.0,bottom: 20),
                            child: Text(
                              date,
                              style: Styler.mediumText
                            ),
                          ),
                          
                          DatePicker (
                            DateTime.now(),
                            height: 100,
                            width: 80,
                            initialSelectedDate: DateTime.now(),
                            selectionColor: Colors.red,
                            selectedTextColor: Colors.white,
                            onDateChange: (sdate) {
                              setState(() {
                                queryDate = sdate;
                                date = DateFormat.yMMMd().format(sdate);
                              });
                            },
                          )
                        ],
                      ),
                  ),
                  
                  Expanded(
                    child: FutureBuilder<List<Promise>>(
                      future: DatabaseHelper.instance.queryByDate(queryDate),
                      builder:(context, snapshot) {
                        if (!snapshot.hasData){
                          return Center(child: Text("Loading..."));
                        }
                        if (snapshot.data!.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/boring.gif")
                                  ,Text(
                                    textAlign: TextAlign.center,
                                    "I am feeling bored today!\nLet's add one promise for self-improvement.",
                                    style: TextStyle(
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            )
                          );
                        }
                        return ListView(
                          children: snapshot.data!.map ((promise){
                            return PromiseCardWidget(
                              id: promise.id,
                              title: promise.title, desc: promise.description,
                              coloring: promise.coloring,
                              setState: () {
                                setState(() {});
                              },
                              );
                          }).toList(),
                        );
                      },
                    )

                    
                  ),
                  
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/addPromise");
                },
                child: Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Image(
                    image: AssetImage("assets/images/plus.png")
                    )
                  ),
              ),
              ),
            ]
          ) ,
        ),
      )
    );
  }
}

