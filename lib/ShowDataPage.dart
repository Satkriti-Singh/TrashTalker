import 'package:flutter/material.dart';
import 'package:trash_talker/workers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trash_talker/AddWorker.dart';

class ShowDataPage extends StatefulWidget{
  @override
  ShowDataPageState createState() => ShowDataPageState();
}
class ShowDataPageState extends State<ShowDataPage>{
  List<workers> allData = [];

  @override
  void initState(){

    DatabaseReference ref =FirebaseDatabase.instance.reference();
    ref.child('workersList').once().then((DataSnapshot snap){
      var keys = snap.value.keys;
      var data =  snap.value;
      allData.clear();
      for(var key in keys){
        allData.add(new workers(key,data[key]['name'], data[key]['address'], data[key]['age'],data[key]['date'], data[key]['credits']));
      }
      setState(() {
      // print('Length: $allData.length'); 
      });
    });
  }

_deleteTodo(String id, int index) {
  FirebaseDatabase.instance.reference().child('workersList').child(id).remove().then((_) {
    print("Delete $id successful");
       Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("$id dismissed")));
 
    setState(() {
      allData.removeAt(index);
    });
  });
}

  @override
  Widget build(BuildContext context){
return Scaffold(
  appBar: new AppBar(
    title: new Text("Trash Talker"),
  ),
  body: new Container(
  margin: EdgeInsets.all(20.0),
    child: allData.length == 0 ? new Text('No data is available'):
    new ListView.builder(
      itemBuilder: (_,index){
         final item = allData[index].name;
        return Dismissible(
         key:Key(item),
          onDismissed: (direction){
            _deleteTodo(allData[index].id, index);
 },
 background: Container(color:Color.fromRGBO(255,219,88, 0.95),
 child: Icon(Icons.delete),
 margin: EdgeInsets.all(5.0),
 ),
          child:  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: ListTile(
           leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.account_circle ,color: Colors.white),
        ),
          title: Text(allData[index].name , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
          subtitle: Text(allData[index].credits , style: TextStyle(color: Colors.white)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          onTap: () => onTapped(allData[index].name,allData[index].address,allData[index].date,allData[index].age,allData[index].credits),
        ),
      ),
    ),
        );
    },
    itemCount: allData.length,
    
    )
  ),

  floatingActionButton: FloatingActionButton(
    backgroundColor: Color.fromRGBO(255,219,88, .85),
    
    child: const Icon(
      Icons.add,
      size: 30.0,
      color: Colors.blueGrey,
    ),
    onPressed: () {
       Navigator.push(context, MaterialPageRoute(builder:(context) => new AddWorker()),);
    },

  ),

  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

  bottomNavigationBar: BottomAppBar(
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {},
        ),
      
      ],
    ),
    color: Color.fromRGBO(64, 75, 96, .9),
    shape: CircularNotchedRectangle()
    
  ),
  );
  }

void onTapped(String name, String address, String date, String age,String credits){
  Navigator.push(context, MaterialPageRoute(builder:(context) => new WorkerDetail(name : name,address:address,date:date,age:age,credits:credits)));
  }
}

class WorkerDetail extends StatelessWidget{
  final String name,address,date,age,credits;
  WorkerDetail({Key key,@required this.name,@required this.address,@required this.date,@required this.age,@required this.credits}) :super(key:key);

  @override
  Widget build(BuildContext context){
return Scaffold(
  appBar: new AppBar(
    title: new Text('Worker Details : $name'),
  ),
  body: Column(
    children: <Widget>[
Stack(
  children: <Widget>[

new Container(
  margin: EdgeInsets.only(top: 135.0),
        child: new  Center(
          child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 8.0,
          child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 125.0),
              margin:EdgeInsets.only(top: 50.0,bottom: 10.0),
              child: new Text('$name',style: Theme.of(context).textTheme.title),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: new Text('Address : $address',style: Theme.of(context).textTheme.subhead),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: new Text('Age : $age',style: Theme.of(context).textTheme.subhead),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: new Text('Date of joining : $date',style: Theme.of(context).textTheme.subhead),
            ),
            Container(
              margin: EdgeInsets.only(top:10.0,bottom: 30.0),
              child: new Text('Credits : $credits',style: Theme.of(context).textTheme.subhead),
            ),
          ],
        ) ,
        ),
        )
      ),
      new Center(
  child: new Container(
     margin: new EdgeInsets.only(top: 70.0,left: 125.0),
     alignment: FractionalOffset.centerLeft,
     child: new IconButton(
       icon: Icon(Icons.account_circle,size: 100.0,color: Colors.amberAccent,),
    ),
  ),
),


  ],
)

     
      
    ],
  ),
    );
  }
}