import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trash_talker/ShowDataPage.dart';
import 'package:trash_talker/main.dart';

class AddWorker extends StatefulWidget{
  @override
  AddWorkerState createState() => AddWorkerState();
}

class AddWorkerState extends State<AddWorker>{
String name,age,address,credits,date,gender;
List<DropdownMenuItem<String>> items = [DropdownMenuItem(child: Text('Male'),value: 'Male',),DropdownMenuItem(child: Text('Female'),value: 'Female'),DropdownMenuItem(child: Text('Other'),value: 'Other')];
GlobalKey<FormState> _key = new GlobalKey();
bool autovalidate = false;

  @override
  Widget build(BuildContext context){
     return Scaffold(
        appBar: new AppBar(
          title: Text('Add new worker'),
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Form(
              key: _key,
              autovalidate: autovalidate,
              child:  FormUI(),
            ),
          ),
        ),
    );
  }


  Widget FormUI(){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      
        Row(
          children: <Widget>[
            Flexible(
              child:  TextFormField(
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder()
          ),
          maxLength: 20,
          validator: validateName,
          onSaved: (val){
            name=val;
          },
        ),
            )
          ],
        ),
        new SizedBox(
          height: 20.0,
        ),
      
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder()
          ),
          maxLength: 30,
          validator: validateAddress,
          onSaved: (val){
            address=val;
          },
        ),

        DropdownButtonHideUnderline(
          child:DropdownButton(
          items: items,
          hint: Text('Gender'),
          value: gender,
          onChanged: (val){
            gender=val;
          },
        ), 
        ),
        new SizedBox(
          height: 20.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Date of joining',
            border: OutlineInputBorder()
          ),
          keyboardType: TextInputType.datetime,
          validator: validateDate,
          onSaved: (val){
            date=val;
          },
        ),

        new SizedBox(
          height: 20.0,
        ),

        TextFormField(
          decoration: InputDecoration(
            labelText: 'Credits',
            border: OutlineInputBorder()
          ),
          maxLength: 3,
          keyboardType: TextInputType.number,
          validator: validateCredits,
          onSaved: (val){
            credits=val;
          },
        ),
        new SizedBox(
          height: 20.0,
        ),
      
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder()
          ),
          maxLength: 2,
          keyboardType: TextInputType.number,
          validator: validateAge,
          onSaved: (val){
            age=val;
          },
        ),

        RaisedButton(onPressed: sendToServer,child: Text('Add worker'),)
      ],
    );

    
  }

  sendToServer(){
  if(_key.currentState.validate()){
    _key.currentState.save();
    DatabaseReference ref =FirebaseDatabase.instance.reference();
    var data={
      "name":name,
      "date":date,
      "credits":credits,
      "age":age,
      "address":address
    };
    ref.child('workersList').push().set(data).then((v){
      _key.currentState.reset();
    });
    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>MyApp()));
    } 
  else{
    setState(() {
     autovalidate=true; 
    });
  }
  }    
  String validateName(String val){
    return val.length == 0 ? "Enter the name of the worker" : null;
    }
       String validateAddress(String val){
        return val.length == 0 ? "Enter the address of the worker" : null;
      }
       String validateAge(String val){
        return val.length == 0 ? "Enter the age of the worker" : null;
      }
       String validateDate(String val){
        return val.length == 0 ? "Enter the date of joining of the worker" : null;
      }
      String validateCredits(String value){
        if(value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if(n == null) {
    return 'Enter valid credits of the worker';
    }
    return null;
    }
}