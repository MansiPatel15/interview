import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewProduct extends StatefulWidget {

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ViewProduct"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasData)
          {
            if(snapshot.data.size<=0)
            {
              return Center(child: Text("No Data"));
            }
            else
            {
              return ListView(
                children: snapshot.data.docs.map((document){
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      color: Colors.purple,
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          //Image.network(document["fileurl"].toString(),height: 200.0,width: 300,),
                          Divider(
                            color: Colors.white,
                          ),
                          Text(document["pname"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Divider(
                            color: Colors.white,
                          ),
                          Text(document["pdesc"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Divider(
                            color: Colors.white,
                          ),
                          Text(document["rprice"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Divider(
                            color: Colors.white,
                          ),
                          Text(document["sprice"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Divider(
                            color: Colors.white,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(padding: EdgeInsets.all(5)),
                              Container(
                                width: MediaQuery.of(context).size.width/2.3,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    var docid = document.id.toString();
                                    var imagename = document["filename"].toString();
                                    await FirebaseStorage.instance.ref(imagename).delete().then((value) async{
                                      await FirebaseFirestore.instance.collection("Products").doc(docid).delete();
                                    });
                                  },
                                  child: Text("Delete"),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Container(
                                width: MediaQuery.of(context).size.width/2.3,
                                child: ElevatedButton(
                                  onPressed: (){
                                    // var docid = document.id.toString();
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(builder: (context)=> UpdateProduct(docid: docid,))
                                    // );
                                  },
                                  child: Text("Update"),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                            ],
                          )
                        ],
                      )
                  );
                }).toList(),
              );
            }
          }
          else
          {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
