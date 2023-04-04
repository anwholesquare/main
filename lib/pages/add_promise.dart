import 'package:app/main.dart';
import 'package:app/pages/homepage.dart';
import 'package:app/style.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:app/model/promise.dart';

class AddPromise extends StatefulWidget {
  const AddPromise({super.key});

  @override
  State<AddPromise> createState() => _AddPromiseState();
}

class _AddPromiseState extends State<AddPromise> {
  String? title = "";
  String? description = "";
  List<DateRange> dates = [DateRange(startDate: DateTime.now(),endDate: DateTime.now().add(const Duration(days: 3)))];
  int coloring = 0;
  


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

      if (args.value is List<PickerDateRange>) {
        dates = [];
        for (PickerDateRange range in args.value) {
          if (range.startDate != null &&  range.endDate != null) {
            dates.add(DateRange(startDate: range.startDate, endDate: range.endDate));
          }
        }
      }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:24, bottom:10, left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.keyboard_backspace_rounded,
                              size: 36,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) => title = value,
                            decoration: const InputDecoration(
                              hintText: "Enter Title",
                              border: InputBorder.none,
                              
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ]
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) => description = value,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: "Write your promise here...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                            // Column (children: const [
                            //   PromiseCheckBox(promiseText: "Yo Boys"),
                            //   PromiseCheckBox(),
                            //   PromiseCheckBox(),
                            // ]),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.centerLeft,
                              child: Text("Pick dates for your promise", 
                              style: Styler.smallText,
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: SfDateRangePicker(
                                view: DateRangePickerView.month,
                                selectionMode: DateRangePickerSelectionMode.multiRange,
                                onSelectionChanged: _onSelectionChanged,
                                initialSelectedRanges: <PickerDateRange>[
                                  PickerDateRange(DateTime.now(), DateTime.now().add(const Duration(days: 3)))
                                ],
                                selectionTextStyle: Styler.smallText,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.centerLeft,
                              child: Text("Color of your promise", 
                              style: Styler.smallText,
                              )
                            ),
                            Row(
                              children:  [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      coloring = 0;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 18,
                                      child: (coloring == 0) ?  const Icon(Icons.check, color: Colors.white) : null,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      coloring = 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 18,
                                      child: (coloring == 1) ?  const Icon(Icons.check, color: Colors.white) : null,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      coloring = 2;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 18,
                                      child: (coloring == 2) ? const Icon(Icons.check, color: Colors.white) : null,
                                    ),
                                  ),
                                ),
                                
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ],
              )
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    if (title!.isNotEmpty && description!.isNotEmpty && dates.isNotEmpty){
                      Promise promise = Promise(title: title, description: description, dates: dates, coloring: coloring, isCompleted: false );
                      DatabaseHelper.instance.insert(promise);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                        content: Text("Please fill up all the inputs and select date range by tapping on two distinct dates."),
                      ));
                    }
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
                    child: Image.asset("assets/images/check.png"),
                ),
              ),
              )
            ),
          ],
        ),
      )
    );
  }
}