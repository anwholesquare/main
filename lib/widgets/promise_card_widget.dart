// ignore: file_names
import 'package:app/main.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';

class PromiseCardWidget extends StatefulWidget  {
  
  final String? title;
  final String? desc;
  final int? id;
  final int? coloring;
  final Function()? setState;
  const PromiseCardWidget({super.key, this.id, this.title, this.desc, this.setState, this.coloring});

  @override
  State<PromiseCardWidget> createState() => _PromiseCardWidgetState();
}

class _PromiseCardWidgetState extends State<PromiseCardWidget> with SingleTickerProviderStateMixin {
  
  late Animation<int> animation;
  late AnimationController animControl;

  @override
  void initState() {
    
    super.initState();
    animControl = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
    animation = IntTween(begin: 0, end: 1).animate(animControl)
    ..addListener(() {
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    animControl.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          
        },
        onLongPress: () {
          DatabaseHelper.instance.deletePromise(widget.id!);
          widget.setState!();
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                          backgroundColor: (animation.value == 0) ? Theme.of(context).textTheme.bodyLarge!.color : (widget.coloring == 0) ? Colors.red : (widget.coloring == 1) ? Colors.green : Colors.blue,
                          radius: 4,

                    ),
                  )
                  ,Text(
                    widget.title ?? "Unknown Promise", style: Styler.mediumText
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(
                 widget.desc ?? "No Description Found",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}