import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_final/pages/profile.dart';
import 'package:tiktok_final/pages/profile.dart';
import 'package:tiktok_final/pages/profile.dart';
import 'package:tiktok_final/variables.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
///result will take some time thats why we used future
  Future<QuerySnapshot> searchresult;
  searchuser(String typpeduser){
    ///will search in username and give results of username  starting with the typped letter
    var users = usercollection.where("username",isGreaterThan: typpeduser).get();
    setState(() {
      searchresult = users;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECE5DA),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            hintText: "Search",
            hintStyle: mystyle(18,),
          ),
          onFieldSubmitted: searchuser,
        ),

      ),
      body: searchresult == null ? Center(child:Text("Search for FlikTokers",style: mystyle(25))
    ):FutureBuilder(
          future: searchresult,
          builder: (BuildContext context ,snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              //to show listr in body
              //itemcount to show collect item to show
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot user = snapshot.data.docs[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> ProfilePage(user.data()['uid'])));
                  },
                  child: ListTile(
                    leading: Icon(Icons.search),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(user.data()['profilepic']),
                    ),
                    title: Text(user.data()['username'],style: mystyle(20),),
                  ),
                );
              },
            );
      })
    );
  }
}
