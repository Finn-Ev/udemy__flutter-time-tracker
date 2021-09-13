import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid});
  final String uid;

  Future<void> createJob(Job job) async =>
      _setData(path: APIPath.job(uid, 'id'), data: job.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    print('$path: $data');
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
}
