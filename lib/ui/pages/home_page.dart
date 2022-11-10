import 'package:codigo2_qr/db/db_admin.dart';
import 'package:codigo2_qr/models/qr_model.dart';
import 'package:codigo2_qr/providers/db_provider.dart';
import 'package:codigo2_qr/providers/example_provider.dart';
import 'package:codigo2_qr/ui/general/colors.dart';
import 'package:codigo2_qr/ui/pages/scanner_page.dart';
import 'package:codigo2_qr/ui/widgets/button_filter_widget.dart';
import 'package:codigo2_qr/ui/widgets/general_widget.dart';
import 'package:codigo2_qr/ui/widgets/item_list_widget.dart';
import 'package:codigo2_qr/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String buttonValue = "Hoy";

  // List<QRModel> qrList = [];
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DBProvider dbProvider = Provider.of<DBProvider>(context, listen: false);
      dbProvider.getDataProvider();
    });
  }

  //
  // Future<void> getData() async {
  //   qrList = await DBAdmin.db.getQRData();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    ExampleProvider _exampleProvider = Provider.of<ExampleProvider>(context);
    DBProvider _dbProvider = Provider.of<DBProvider>(context, listen: true);
    print("BUILD HOME!!!!!");

    return Scaffold(
      backgroundColor: kBrandSecondaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScannerPage()));
        },
        backgroundColor: kBrandPrimaryColor,
        child: SvgPicture.asset(
          Assets.iconQrScan,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        divider40,
                        Text(
                          _exampleProvider.counter.toString(),
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          "Historial de Escaneos",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xff1E1E1E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        divider6,
                        Text(
                          "En esta sección podrás visualizar el historial de elementos registrados, también puedes agregar nuevos ingresos cuando tú prefieras.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 1.6,
                            color: Color(0xff1E1E1E).withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        divider30,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonFilterWidget(
                              text: "Hoy",
                              isSelected: buttonValue == "Hoy",
                              onTap: () {
                                buttonValue = "Hoy";
                                setState(() {});
                              },
                            ),
                            dividerWidth14,
                            ButtonFilterWidget(
                              text: "Todos",
                              isSelected: buttonValue == "Todos",
                              onTap: () {
                                buttonValue = "Todos";
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     physics: const BouncingScrollPhysics(),
                  //     child: Column(
                  //       children: qrList.map((QRModel e) => ItemListWidget(model: e,)).toList(),
                  //     ),
                  //   ),
                  // ),

                  // Expanded(
                  //   child: ListView.builder(
                  //     physics: const BouncingScrollPhysics(),
                  //     itemCount: qrList.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return ItemListWidget(
                  //         model: qrList[index],
                  //       );
                  //     },
                  //   ),
                  // ),
                  // _dbProvider.isLoading ? CircularProgressIndicator() : Text(_dbProvider.qrList.toString()),

                  // Consumer<DBProvider>(
                  //   builder: (context, provider, _){
                  //     return !provider.isLoading ? Expanded(
                  //       child: ListView.builder(
                  //         physics: const BouncingScrollPhysics(),
                  //         itemCount: provider.qrList.length,
                  //         itemBuilder: (BuildContext context,int index){
                  //           return ItemListWidget(
                  //             model: provider.qrList[index],
                  //           );
                  //         },
                  //       ),
                  //     ): Center(child: CircularProgressIndicator(),);
                  //   },
                  // ),

                  !_dbProvider.isLoading
                      ? Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _dbProvider.qrList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemListWidget(
                                model: _dbProvider.qrList[index],
                              );
                            },
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),

                  // FutureBuilder(
                  //   future: DBAdmin.db.getQRData(),
                  //   builder: (BuildContext context, AsyncSnapshot snap){
                  //     if(snap.hasData){
                  //       List<QRModel> list = snap.data;
                  //       return Expanded(
                  //         child: ListView.builder(
                  //           physics: const BouncingScrollPhysics(),
                  //           itemCount: list.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             return ItemListWidget(
                  //               model: list[index],
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     }
                  //     return Center(child: CircularProgressIndicator(),);
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
