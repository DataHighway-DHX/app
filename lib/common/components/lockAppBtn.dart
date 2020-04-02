import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/selectPicker.dart';

Widget lockAppBtn(context,String btnName,{int selectedValue = 0,Function onSelected}){
  List selectData = ['MXC','IOTA'];
  
  return Container(
    padding: const EdgeInsets.only(top:30),
    child:  Row(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 0,right: 10,left: 10,bottom: 10),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: OutlineButton(
            borderSide: BorderSide(
              color: Colors.deepPurple
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Text(
              btnName,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white
              ),
            ),
            onPressed: () {}
          )
        ),
        Row(
          children: <Widget>[
            Text(
              selectData[selectedValue],
              textAlign: TextAlign.center,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () => selectPicker(
                context, 
                data: selectData, 
                value:selectedValue, 
                onSelected: (index){
                if(onSelected != null){
                  onSelected(index,selectData[index]);
                }
              })
            )
          ],
        ),
        Expanded(
          child: Container(),
        ),
      ]
    )
);
}