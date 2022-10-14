import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:udemy_snsapp/model/account.dart';
import 'package:udemy_snsapp/utils/authentication.dart';
import 'package:udemy_snsapp/utils/firestore/posts.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch(e) {
      print('新規ユーザー作成エラー: $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
        selfIntroduction: data['self_introduction'],
        imagePath: data['image_path'],
        createdTime: data['created_time'],
        updatedTime: data['updated_time'],
      );
      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch(e) {
      print('ユーザー取得エラー');
      return false;
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'image_path': updateAccount.imagePath,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'update_time': Timestamp.now()
      });
      print('ユーザー情報の更新完了');
      return true;
    } on FirebaseException catch(e) {
      print('ユーザー情報の更新エラー: $e');
      return false;
    }
  }

  static Future<Map<String, Account>?>  getPostUserMap(List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async{
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          selfIntroduction: data['self_introduction'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time']
        );
        map[accountId] = postAccount;
      });
      print('投稿ユーザーの情報取得完了');
      return map;
    } on FirebaseException catch(e) {
      print('投稿ユーザーの情報取得エラー');
      return null;
    }
  }

  static Future<dynamic> deleteUser(String accountId) async{
    users.doc(accountId).delete();
    PostFirestore.deletePosts(accountId);
  }


}