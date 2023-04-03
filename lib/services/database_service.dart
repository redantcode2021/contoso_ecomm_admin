import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contoco_ecom_admin/models/order_stats_model.dart';

import '../models/models.dart';
import '../models/order_model.dart' as order;

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addProduct(Product product) {
    return _firebaseFirestore.collection('products').add(product.toMap());
  }

  Future<void> updateField(Product product, String field, dynamic newValue) {
    return _firebaseFirestore
        .collection('products')
        .where('id', isEqualTo: product.id)
        .get()
        .then(
          (querySnapshot) => {
            querySnapshot.docs.first.reference.update({field: newValue})
          },
        );
  }

  Stream<List<order.Order>> getOrders() {
    return _firebaseFirestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => order.Order.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<order.Order>> getPendingOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isCancelled', isEqualTo: false)
        .where('isDelivered', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => order.Order.fromSnapshot(doc)).toList();
    });
  }

  Future<void> updateOrder(order.Order order, String field, dynamic newValue) {
    return _firebaseFirestore
        .collection('orders')
        .where('id', isEqualTo: order.id)
        .get()
        .then(
          (querySnapshot) => {
            querySnapshot.docs.first.reference.update({field: newValue})
          },
        );
  }

  Future<List<OrderStats>> getOrderStats() {
    return _firebaseFirestore
        .collection('order_stats')
        .orderBy('dateTime')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => OrderStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }
}
