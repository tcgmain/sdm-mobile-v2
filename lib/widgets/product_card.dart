// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class ProductCard extends StatelessWidget {
  final String? productCode;
  final String? productName;
  final String? stock;
  final bool? isRightWidgetAvailable;
  final VoidCallback onChangedFunction;
  final VoidCallback onPressedFunction;

  const ProductCard({
    super.key,
    required this.productCode,
    required this.productName,
    required this.stock,
    required this.isRightWidgetAvailable,
    required this.onChangedFunction,
    required this.onPressedFunction,
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
            '$productCode - $productName',
            style: TextStyle(color: CustomColors.cardBoldTextColor, fontSize: getFontSizeSmall(), fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Stock: $stock',
              style: TextStyle(fontSize: getFontSize(), color: CustomColors.cardTextColor),
            ),
            trailing: isRightWidgetAvailable == true
                ? Container(
                    alignment: Alignment.centerRight,
                    width: 150,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'New Stock',
                              // border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: CustomColors.cardTextUnderlined, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: CustomColors.buttonColor, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              onChangedFunction();
                            },
                          ),
                        ),
                        IconButton(
                          color: CustomColors.buttonColor,
                          icon: const Icon(Icons.update),
                          onPressed: () {
                            onPressedFunction();
                          },
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: 150,
                  ),
            contentPadding: const EdgeInsets.all(0),
          ),
        ],
      ),
    );
  }
}
