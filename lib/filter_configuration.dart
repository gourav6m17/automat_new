import 'dart:developer';

import 'package:automat/Constant/const.dart';
import 'package:automat/services/automat_services.dart';
import 'package:automat/ui/basic/dp_count.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FilterConfiguration extends StatefulWidget {
  final String deviceId;
  const FilterConfiguration({Key? key, required this.deviceId})
      : super(key: key);

  @override
  State<FilterConfiguration> createState() => _FilterConfigurationState();
}

class _FilterConfigurationState extends State<FilterConfiguration> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final automatServices = AutomatServices();
  flushingMode() async {
    final mode = await automatServices.readFlushingMode(widget.deviceId);
    log("----flush---------" + mode);
    if (mode == '1') {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          showDpOnly = true;
          showDpTime = false;
        });
      });
    } else if (mode == '2') {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          showDpTime = true;
          showDpOnly = false;
        });
      });
    }

    //return mode;
  }

  operationMode() async {
    log("enter");
    final mode = await automatServices.readOperationMode(widget.deviceId);
    log("-----operation--------" + mode);
    if (mode == '1') {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          showStandAlone = true;
          showBattery = false;
        });
      });
    } else if (mode == '2') {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          showBattery = true;
          showStandAlone = false;
        });
      });
    }

    //return mode;
  }

  getModes() {
    operationMode();
    flushingMode();
  }

  check() {
    automatServices.writeSave(widget.deviceId,
        [49, 49, 48, 49, 53, 59, 48, 49, 48, 52, 48, 52, 49, 51]);
  }

  final intervalHrController = TextEditingController();
  final intervalMinController = TextEditingController();
  final durationMinController = TextEditingController();
  final durationSecController = TextEditingController();
  final dpDelaySecController = TextEditingController();
  final loopingCycleCountController = TextEditingController();
  final technicianPassword = TextEditingController();

  _showDialog(BuildContext context, Function()? function) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "enter_techinician_password".tr,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   "(Device Name here)",
                    //   style: TextStyle(color: Colors.grey),
                    // ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: technicianPassword,
                    decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kGreyColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kGreyColor)))),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => kPrimaryColor)),
                          onPressed: () {
                            getModes();
                            Navigator.of(context).pop();
                          },
                          child: Text("cancel".tr)),
                    ),
                    const Spacer(),
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => kPrimaryColor)),
                            onPressed: function,
                            child: Text("save".tr)))
                  ],
                ),
              ),
            ],
          );
        });
  }

  var initialIndex = 0;
  bool? showDpOnly;
  bool? showBattery;
  bool? showStandAlone;
  bool? showDpTime;
  @override
  void initState() {
    //getModes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: height * 0.07,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    side: BorderSide(color: kPrimaryColor))),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => kPrimaryColor)),
                        onPressed: () {
                          _showDialog(
                            context,
                            () {
                              automatServices.writeRestore(widget.deviceId);
                            },
                          );
                        },
                        child: Text(
                          'restore'.tr,
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontSize: 20,
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: height * 0.07,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      side: BorderSide(color: kPrimaryColor))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => kPrimaryColor)),
                      onPressed: () {
                        _showDialog(
                          context,
                          () {
                            check();
                          },
                        );
                        setState(() {});
                      },
                      child: Text(
                        'save'.tr,
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 77, 221, 101),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              tooltip: "Back",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: Text(
              'filter_configuration'.tr,
            )),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Center(
                      //       child: Text(
                      //     'filter_configuration'.tr,
                      //     style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold),
                      //   )),
                      // ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                              // height: height * 0.14,
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 2,
                                        offset: Offset.zero)
                                  ]),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'operation_mode'.tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  // FutureProvider<String>(
                                  //   create: (_) => automatServices
                                  //       .readOperationMode(widget.deviceId),
                                  //   initialData: '1',
                                  //   child: Consumer<String>(
                                  //     builder: (context, value, child) {
                                  //       //log("flu-------" + value);
                                  //       if (value == '1') {
                                  //         WidgetsBinding.instance!
                                  //             .addPostFrameCallback((_) {
                                  //           setState(() {
                                  //             showStandAlone = true;
                                  //             showBattery = false;
                                  //           });
                                  //         });
                                  //       } else if (value == '2') {
                                  //         WidgetsBinding.instance!
                                  //             .addPostFrameCallback((_) {
                                  //           setState(() {
                                  //             showBattery = true;
                                  //             showStandAlone = false;
                                  //           });
                                  //         });
                                  //       }
                                  //       return
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          side: (showStandAlone ==
                                                                      true &&
                                                                  showBattery ==
                                                                      false)
                                                              ? BorderSide.none
                                                              : const BorderSide(
                                                                  color:
                                                                      kPrimaryColor))),
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith((states) =>
                                                          (showStandAlone == true &&
                                                                  showBattery == false)
                                                              ? kPrimaryColor
                                                              : kWhiteColor)),
                                              onPressed: () {
                                                setState(() {
                                                  showBattery = false;
                                                  showStandAlone = true;
                                                });
                                              },
                                              child: Text(
                                                'stand_alone'.tr,
                                                style: TextStyle(
                                                  color: (showStandAlone ==
                                                              true &&
                                                          showBattery == false)
                                                      ? kWhiteColor
                                                      : kPrimaryColor,
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          side: (showBattery == true &&
                                                                  showStandAlone ==
                                                                      false)
                                                              ? BorderSide.none
                                                              : const BorderSide(
                                                                  color:
                                                                      kPrimaryColor))),
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith((states) =>
                                                          (showBattery == true &&
                                                                  showStandAlone ==
                                                                      false)
                                                              ? kPrimaryColor
                                                              : kWhiteColor)),
                                              onPressed: () {
                                                setState(() {
                                                  showBattery = true;
                                                  showStandAlone = false;
                                                });
                                              },
                                              child: Text(
                                                'battery_of_filters'.tr,
                                                style: TextStyle(
                                                  color: (showBattery == true &&
                                                          showStandAlone ==
                                                              false)
                                                      ? kWhiteColor
                                                      : kPrimaryColor,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              )),
                        ),
                      ),
                      // FutureProvider<String>(
                      //   updateShouldNotify: (_, __) => false,
                      //   create: (_) =>
                      //       automatServices.readFlushingMode(widget.deviceId),
                      //   initialData: '0',
                      //   child: Consumer<String>(
                      //     builder: (context, value, child) {
                      //       if (value == '1') {
                      //         WidgetsBinding.instance!
                      //             .addPostFrameCallback((timeStamp) {
                      //           setState(() {
                      //             showDpOnly = true;
                      //             showDpTime = false;
                      //           });
                      //         });
                      //       } else if (value == '2') {
                      //         WidgetsBinding.instance!
                      //             .addPostFrameCallback((timeStamp) {
                      //           setState(() {
                      //             showDpTime = true;
                      //             showDpOnly = false;
                      //           });
                      //         });
                      //       }
                      //       //log("flu-------" + value);
                      //       return
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                            //height: height * 0.14,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 2,
                                      offset: Offset.zero)
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'flushing_mode'.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        side: (showDpOnly ==
                                                                    true &&
                                                                showDpTime ==
                                                                    false)
                                                            ? BorderSide.none
                                                            : const BorderSide(
                                                                color:
                                                                    kPrimaryColor))),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            showDpOnly == true
                                                                ? kPrimaryColor
                                                                : kWhiteColor)),
                                            onPressed: () {
                                              setState(() {
                                                showDpTime = false;
                                                showDpOnly = true;
                                              });
                                            },
                                            child: Text(
                                              'dp_only'.tr,
                                              style: TextStyle(
                                                color: showDpOnly == true
                                                    ? kWhiteColor
                                                    : kPrimaryColor,
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        side: (showDpTime ==
                                                                    false &&
                                                                showDpOnly ==
                                                                    false)
                                                            ? const BorderSide(
                                                                color:
                                                                    kPrimaryColor)
                                                            : BorderSide.none)),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            showDpTime == false
                                                                ? kWhiteColor
                                                                : kPrimaryColor)),
                                            onPressed: () {
                                              setState(() {
                                                showDpTime = true;
                                                showDpOnly = false;
                                              });
                                            },
                                            child: Text(
                                              'dp&time'.tr,
                                              style: TextStyle(
                                                color: showDpTime == true
                                                    ? kWhiteColor
                                                    : kPrimaryColor,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      //     },
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                            height: height * 0.10,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color:
                                    (showDpOnly == true && showDpTime == false)
                                        ? kGreyColor.withOpacity(0.1)
                                        : Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 2,
                                      offset: Offset.zero)
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'flushing_interval'.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.2,
                                        color: Colors.grey.shade100,
                                        child: TextField(
                                          controller: intervalHrController,
                                          enabled: (showDpOnly == true)
                                              ? false
                                              : true,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                              //  border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'hr'.tr,
                                              contentPadding:
                                                  const EdgeInsets.all(12),
                                              hintTextDirection:
                                                  TextDirection.rtl),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.2),
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.2,
                                        color: Colors.grey.shade100,
                                        child: TextField(
                                          controller: intervalMinController,
                                          enabled: (showDpOnly == true)
                                              ? false
                                              : true,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                              //  border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'min'.tr,
                                              contentPadding:
                                                  const EdgeInsets.all(12),
                                              hintTextDirection:
                                                  TextDirection.rtl),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                            height: height * 0.10,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color:
                                    (showDpTime == false && showDpOnly == false)
                                        ? kGreyColor.withOpacity(0.1)
                                        : Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 2,
                                      offset: Offset.zero)
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'flushing_duration'.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.2,
                                        color: Colors.grey.shade100,
                                        child: TextField(
                                          controller: durationMinController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                              //  border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'min'.tr,
                                              contentPadding:
                                                  const EdgeInsets.all(12),
                                              hintTextDirection:
                                                  TextDirection.rtl),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.2),
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.2,
                                        color: Colors.grey.shade100,
                                        child: TextField(
                                          controller: durationSecController,
                                          // enabled: (showDpTime == false &&
                                          //         showDpOnly == false)
                                          //     ? true
                                          //     : false,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                              //  border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'sec'.tr,
                                              // contentPadding:
                                              //     EdgeInsets.all(12),
                                              hintTextDirection:
                                                  TextDirection.rtl),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                //flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          height: height * 0.06,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 2,
                                    offset: Offset.zero)
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'dp_delay'.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: height * 0.04,
                                  width: width * 0.2,
                                  color: Colors.grey.shade100,
                                  child: TextField(
                                    controller: dpDelaySecController,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'sec'.tr,
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        hintTextDirection: TextDirection.rtl),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          height: height * 0.06,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 2,
                                    offset: Offset.zero)
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'looping_cycle'.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: height * 0.04,
                                  width: width * 0.2,
                                  color: Colors.grey.shade100,
                                  child: TextField(
                                    controller: loopingCycleCountController,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        //  border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'count'.tr,
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        hintTextDirection: TextDirection.rtl),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(4),
              //   child:
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Expanded(
              //           child: ElevatedButton(
              //               style: ButtonStyle(
              //                   shape: MaterialStateProperty.all<
              //                           RoundedRectangleBorder>(
              //                       const RoundedRectangleBorder(
              //                           side: BorderSide(
              //                               color: kPrimaryColor))),
              //                   backgroundColor:
              //                       MaterialStateProperty.resolveWith(
              //                           (states) => kPrimaryColor)),
              //               onPressed: () {},
              //               child: const Text(
              //                 'Restore',
              //                 style: const TextStyle(
              //                   color: kWhiteColor,
              //                 ),
              //               )),
              //         ),
              //         const Spacer(),
              //         Expanded(
              //           child: ElevatedButton(
              //               style: ButtonStyle(
              //                   shape: MaterialStateProperty.all<
              //                           RoundedRectangleBorder>(
              //                       const RoundedRectangleBorder(
              //                           side: const BorderSide(
              //                               color: kPrimaryColor))),
              //                   backgroundColor:
              //                       MaterialStateProperty.resolveWith(
              //                           (states) => kPrimaryColor)),
              //               onPressed: () {
              //                 setState(() {});
              //               },
              //               child: const Text(
              //                 'Save',
              //                 style: TextStyle(
              //                   color: kWhiteColor,
              //                 ),
              //               )),
              //         ),
              //       ],
              //     ),
              //   ),

              // ),
            ],
          ),
        ),
      ),
    );
  }
}
