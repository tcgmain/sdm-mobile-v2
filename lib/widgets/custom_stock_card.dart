import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdm/utils/constants.dart';

class CustomStockCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String availableStock;
  final TextEditingController newStockController;
  final VoidCallback onPressedUpdate;
  final String lastUpdatedDate;
  final String lastUpdatedUser;

  const CustomStockCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.availableStock,
    required this.newStockController,
    required this.onPressedUpdate,
    required this.lastUpdatedDate,
    required this.lastUpdatedUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade400,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$productId - $productName',
            style: TextStyle(color: const Color(0xff3b3b3b), fontSize: getFontSizeSmall(), fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Stock: $availableStock',
              style: TextStyle(fontSize: getFontSize()),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              width: 150,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newStockController,
                      decoration: const InputDecoration(
                        hintText: 'New Stock',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                  ),
                  IconButton(
                    color: CustomColors.buttonColor,
                    icon: const Icon(Icons.update),
                    onPressed: () {
                      onPressedUpdate();
                    },
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(0),
          ),
          Text(
            "Last Modified $lastUpdatedDate by $lastUpdatedUser",
            style: TextStyle(fontSize: getFontSizeExtraSmall()),
          )
        ],
      ),
    );
  }
}
