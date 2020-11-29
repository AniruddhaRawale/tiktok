import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_final/policy.dart';
import 'package:tiktok_final/variables.dart';

class signuppage extends StatefulWidget {
  @override
  _signuppageState createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {

  //to get data from textfield

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();

  registeruser(){
    //create user with email and password
    //save his credentials
    //authenticate the user with the same credentials

    //to save user in firebase authentication
    ///to save user in cloud firebase use .then portion
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
    ).then((signeduser){
      usercollection.doc(signeduser.user.uid).set({
        'username': usernamecontroller.text,
        'password':passwordcontroller.text,
        'email':emailcontroller.text,
        'uid':signeduser.user.uid,
        'profilepic':'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'
      });
    });
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Lets Go",style: mystyle(25,Colors.black,FontWeight.w600),),
              SizedBox(height: 10,),
              Text("Sign Up",style: mystyle(25,Colors.black,FontWeight.w600),),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.00,right: 20.0),
                child: TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Email',
                      labelStyle: mystyle(20),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.00,right: 20.0),
                child: TextField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'UserName',
                      labelStyle: mystyle(20),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.00,right: 20.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Password',
                      labelStyle: mystyle(20),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                ),
              ),
              SizedBox(height: 10.00,),
              InkWell(
                onTap: () => registeruser(),
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Center(
                    child: Text("Register",style: mystyle(20,Colors.white,FontWeight.w700),),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("I agree to",style: mystyle(20),),
                  SizedBox(width: 10,),
                  InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (contexte) => terms())),
                      child: Text("Terms & Condition's",style: mystyle(20,Colors.purple),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

