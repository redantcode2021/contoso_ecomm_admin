import 'package:contoco_ecom_admin/controllers/order_controller.dart';
import 'package:contoco_ecom_admin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key}) : super(key: key);
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                  itemCount: orderController.pendingOrders.length,
                  itemBuilder: (BuildContext context, index) {
                    return OrderCard(
                        order: orderController.pendingOrders[index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  OrderCard({Key? key, required this.order}) : super(key: key);

  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    var products = Product.products
        .where((product) => order.productIds.contains(product.id))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order ID: ${order.id}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd-MM-yy').format(order.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            products[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index].name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 260,
                              child: Text(
                                products[index].description,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Delivery Fee",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${order.deliveryFee}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${order.total}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  order.isAccepted
                      ? ElevatedButton(
                          onPressed: () {
                            orderController.updateOrder(
                              order,
                              'isDelivered',
                              !order.isDelivered,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(150, 40),
                          ),
                          child: const Text(
                            "Deliver",
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            orderController.updateOrder(
                              order,
                              'isAccepted',
                              !order.isAccepted,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(150, 40),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                  ElevatedButton(
                    onPressed: () {
                      orderController.updateOrder(
                        order,
                        'isCancelled',
                        !order.isCancelled,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
