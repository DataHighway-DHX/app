import 'package:flutter/cupertino.dart';

void selectPicker(context,List data, int selectedValue,cb){
  showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      return Container(
        height: 200.0,
        child: CupertinoPicker(
          itemExtent: 58.0,
          scrollController: FixedExtentScrollController(
            initialItem: selectedValue
          ),
          children: data.map((item) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(item))).toList(),
          onSelectedItemChanged: (index){
            if(cb != null){
              cb(index);
            }
          }
        ),
      );
    }
  );
}