

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_final/variables.dart';

class ProfilePage extends StatefulWidget {

  //to find for which user we are rendering the page
  final String uid;
  ProfilePage(this.uid);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String username;
  String onlineuser;
  String profilepic;
  Future myvideos;
  int likes;
  bool dataisthere = false;
  //to get all data at start of function
  @override
  void initState(){
    super.initState();
    getalldata();
  }

  getalldata()async{


    //get videos as future because it will take some time to get data
    myvideos = videoscollection.where('uid',isEqualTo: widget.uid).get();

    //get user data
    DocumentSnapshot userdoc = await usercollection.doc(widget.uid).get();

    username = userdoc.data()['username'];
    profilepic = userdoc.data()['profilepic'];

    //get all likes
    //we are running for lpoop over arrsy so it will add new videos likes over

    var documents = await videoscollection.where('uid',isEqualTo: widget.uid).get();
    for(var item in documents.docs){
      likes = item.data()['likes'].length + likes;
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dataisthere==false? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    profilepic),
              ),
              SizedBox(height: 20,),
              Text(username,style: mystyle(25,Colors.black,FontWeight.w500),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("34",style: mystyle(23,Colors.black,FontWeight.w500),),
                  Text("50",style: mystyle(23,Colors.black,FontWeight.w500),),
                  Text(likes.toString(),style: mystyle(23,Colors.black,FontWeight.w500),)
                ],
              ),
              SizedBox(height: 7,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Following",style: mystyle(17,Colors.black,FontWeight.w700),),
                  Text("Fans",style: mystyle(17,Colors.black,FontWeight.w700),),
                  Text("Hearts",style: mystyle(17,Colors.black,FontWeight.w700),)
                ],
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40,
                color: Colors.pink,
                child: Center(
                  child: Text("Edit Profile",style: mystyle(20,Colors.white,FontWeight.w600),),
                ),
              ),
              SizedBox(height: 20,),
              Text("My Videos",style: mystyle(20),),
              SizedBox(height: 10,),
              FutureBuilder(
                  future: myvideos,
                  builder: (BuildContext context ,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
               return GridView.builder(
                 physics: NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   itemCount: snapshot.data.docs.length,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1,
               crossAxisSpacing: 5), itemBuilder: (BuildContext context , int index){
                     DocumentSnapshot video = snapshot.data.docs[index];
                     return Container(child: Image(
                       image:NetworkImage(video.data()['previewimage']),
                       fit: BoxFit.cover,
                     ),);
               });
              })
            ],
          ),
        ),
      ),
    );
  }
}
