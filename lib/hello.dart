import 'package:flutter/material.dart';

class ShowText extends StatefulWidget {
  final String abc;
  ShowText({Key key,this.abc}) : super(key: key);

  @override
  _ShowTextState createState() => _ShowTextState();
}

class _ShowTextState extends State<ShowText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Text'),
       ),
      //  body: ListView.builder(
      //    itemCount: widget.abc.length,
      //    itemBuilder: (context,i){
      //      return Card(
      //                   child: ListTile(
               
      //          title:Text( widget.abc[i]),
      //        ),
      //      );
      //    },
      //  ),
      body: Text(widget.abc),
    );
  }
}