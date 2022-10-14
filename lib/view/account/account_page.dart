import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:udemy_snsapp/model/account.dart';
import 'package:udemy_snsapp/model/post.dart';
import 'package:udemy_snsapp/utils/authentication.dart';
import 'package:udemy_snsapp/utils/firestore/posts.dart';
import 'package:udemy_snsapp/utils/firestore/users.dart';
import 'package:udemy_snsapp/view/account/edit_account_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;

  List<Post> postList = [
    Post(
        id: '1',
        content: '初めまして',
        postAccountId: '1',
        createdTime: Timestamp.now()
    ),
    Post(
        id: '2',
        content: '初めまして2かい',
        postAccountId: '2',
        createdTime: Timestamp.now()
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 15, left: 15, top: 20),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                  foregroundImage: NetworkImage(myAccount.imagePath),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(myAccount.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text(myAccount.userId,style: TextStyle(color:Colors.grey),),
                                ],
                              )
                            ],
                          ),
                          OutlinedButton(onPressed: () async{
                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccountPage()));
                            if(result == true) {
                              setState(() {
                                myAccount = Authentication.myAccount!;
                              });

                            }
                          },
                              child: Text('編集')
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(myAccount.selfIntroduction)
                    ],

                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Colors.blue, width: 3
                    ))
                  ),
                  child: Text('投稿')
                ),
                Expanded(child: StreamBuilder<QuerySnapshot>(
                  stream: UserFirestore.users.doc(myAccount.id).collection('my_posts').orderBy('created_time', descending: true)
                    .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      List<String> myPostIds = List.generate(snapshot.data!.docs.length, (index){
                        return snapshot.data!.docs[index].id;
                      });
                      return FutureBuilder<List<Post>?>(
                        future: PostFirestore.getPostsFromIds(myPostIds),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index){
                                  Post post = snapshot.data![index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: index == 0 ? Border(
                                        top: BorderSide(color: Colors.grey, width: 0),
                                        bottom: BorderSide(color: Colors.grey, width: 0),
                                      ) : Border(
                                        bottom: BorderSide(color: Colors.grey, width: 0),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          foregroundImage: NetworkImage(myAccount.imagePath),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(myAccount.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                                        Text(myAccount.userId, style: TextStyle(color: Colors.grey),),
                                                      ],
                                                    ),
                                                    Text(DateFormat('M/d/yy').format(post.createdTime!.toDate()))
                                                  ],
                                                ),
                                                Text(post.content)
                                              ],

                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        }
                      );
                    } else {
                      return Container();
                    }
                  }
                )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
