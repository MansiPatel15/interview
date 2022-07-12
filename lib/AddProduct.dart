import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview/ViewProduct.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _name =TextEditingController();
  TextEditingController _desc =TextEditingController();
  TextEditingController _rprice =TextEditingController();
  TextEditingController _sprice =TextEditingController();

  ImagePicker _picker = ImagePicker();
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AddProduct"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            (file==null)?Image.asset("Image/1.jpg",width: 350,height: 150,):Image.file(file,width: 350.0,height: 150.0),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.3,
                    child:ElevatedButton(
                      onPressed: () async
                      {
                        XFile pickedimage = await _picker.pickImage(source: ImageSource.camera);
                        setState(() {
                          file = File(pickedimage.path);
                        });
                      },
                      child: Text("Camera",style: TextStyle(fontSize: 20),),
                    ) ,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width/2.3,
                      child:ElevatedButton(
                        onPressed: () async
                        {
                          XFile pickedimage = await _picker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            file = File(pickedimage.path);
                          });
                        },
                        child: Text("Gallery",style: TextStyle(fontSize: 20),),
                      )
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Name : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Name'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Description : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _desc,
                minLines: 2,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Description'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Regular Price : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _rprice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a RegularPrice'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "S Price : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _sprice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a SPrice'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.2,
                    child: ElevatedButton(
                      onPressed: () async{
                        var name = _name.text.toString();
                        var pdesc = _desc.text.toString();
                        var rprice = _rprice.text.toString();
                        var sprice = _sprice.text.toString();

                        // Random random = Random();
                        // var filename = random.nextInt(999).toString()+random.nextInt(999).toString()+".jpg";//523856.jpg

                        var uuid = Uuid();
                        var filename = uuid.v1().toString()+".jpg"; //6c84fb90-12c4-11e1-840d-7b25c5ee775a.jpg

                        await FirebaseStorage.instance.ref(filename).putFile(file).whenComplete((){}).then((filedata) async{
                          await filedata.ref.getDownloadURL().then((fileurl) async{

                            await FirebaseFirestore.instance.collection("Products").add({
                              "pname":name,
                              "pdesc":pdesc,
                              "rprice":rprice,
                              "sprice":sprice,
                              "fileurl":fileurl,
                              "filename":filename
                            }).then((value){
                              setState(() {
                                file=null;
                              });
                              _name.text="";
                              _rprice.text="";
                              _desc.text="";
                              _sprice.text="";
                              Fluttertoast.showToast(
                                  msg: "Product Inserted Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>ViewProduct())
                              );
                            });

                          });
                        });
                      },
                      child: Text("Add",style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2.2,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text("Cancel",style: TextStyle(fontSize: 20),),
                    ) ,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
