import 'package:flutter/material.dart';

Widget formulaInput({type = 'input',String value = '',String lable,Function onSelected,TextEditingController controller, Function(String) onChanged}){
  return Expanded(
    child: Column(
      children: <Widget>[
        type == 'input' ?
        Container(
          padding: const EdgeInsets.only(top: 5.0),
          height: 40,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(),
            ),
          ) 
        ) :
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            height: 40,
            // padding: const EdgeInsets.all(5),
            child: TextField(
              readOnly: true,
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(),
              ),
              onTap: onSelected
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            lable,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12
            )
          ),
        )
      ],
    ),
  );
}
