// ignore_for_file: sort_child_properties_last

import 'package:sdm/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomOrderShippingListTile extends StatelessWidget {
  final String? no;
  final String? date;
  final String? orderNo;
  final String? lineNo;
  final List<dynamic>? serialNoArray;

  const CustomOrderShippingListTile({
    super.key,
    @required this.no,
    @required this.date,
    @required this.orderNo,
    @required this.lineNo,
    @required this.serialNoArray,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              child: Center(
                child: Text(no.toString(), style: const TextStyle(fontSize: 16)),
              ),
              height: 105 + (36 * serialNoArray!.length.toDouble()),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                color: Colors.white,
              )),
        ),
        Container(height: 105 + (36 * serialNoArray!.length.toDouble()), width: 5, color: CustomColors.backgroundColor),
        Expanded(
          flex: 6, // 60%
          child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  //1st row
                  Container(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        date.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      )),
                  //2nd row
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          width: 120,
                          child: const Text(
                            "Order No",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          )),
                      Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(
                          orderNo.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: CustomColors.textHighlightColor1,
                        ),
                      )
                    ],
                  ),
                  //3rd row
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          width: 120,
                          child: const Text(
                            "Line No",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          )),
                      Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(
                          lineNo.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: CustomColors.textHighlightColor1,
                        ),
                      )
                    ],
                  ),
                  //4th row
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          width: 120,
                          height: 100,
                          child: const Text(
                            "Serial No",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          )),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(top: 4, right: 15),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(serialNoArray![index].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ));
                            },
                            itemCount: serialNoArray!.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: CustomColors.textHighlightColor1,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              color: Colors.white,
              height: 105 + (36 * serialNoArray!.length.toDouble())),
        ),
      ],
    );
  }
}
