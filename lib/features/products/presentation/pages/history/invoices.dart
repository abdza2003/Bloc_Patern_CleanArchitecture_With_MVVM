import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date;
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/features/products/presentation/bloc/products_bloc.dart';
import 'package:school_cafteria/features/products/presentation/pages/history/invoice_products.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/widgets/loading_widget.dart';

class InvoicesPage extends StatefulWidget {

   const InvoicesPage({Key? key ,required this.childImage, required this.accessToken ,required this.childId, required this.currencyName}) : super(key: key);
  final String childImage;
  final String accessToken;
  final int childId;
  final String currencyName;
   @override
   State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  @override
  void initState() {
    fromDateController.text = ""; //set the initial value of text field
    toDateController.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>( buildWhen: (productsBloc, productsState) {
    if (productsState is LoadedInvoicesState) {
    return true;
    } else {
    return false;
    }
    }, builder: (context, state) {
      if (state is LoadedInvoicesState) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(10.h + 10.w),
              child: AppBar(
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(top: 5.h, right: 0.w),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,textDirection: TextDirection.ltr,
                      children: [

                        Container(
                          height: 7.h + 7.w,
                          width: 42.w,
                          decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage(
                                  'assets/launcher/logo.png'))),),
                        SizedBox(
                           //height: 15.h,
                          width: 30.w,
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child:Image(
                                    image:NetworkImage(Network().baseUrl +widget.childImage,scale: 1.5))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 20,
                  bottomOpacity: 0,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  shadowColor: const Color(0xffFF5DB9),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.elliptical(1100, 500),
                        bottomLeft: Radius.elliptical(550, 350)
                    ),
                  )),
            ),
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.repeat,
                        image: AssetImage('assets/images/bg.png'))),
                child: state.invoices.isEmpty
                    ? Center(
                  child: Text("INVOICE_NO_HISTORY".tr(context)),
                )
                    : ListView(children: [
                  SizedBox(
                    height: 1.h,
                  ),

                  Card(
                    color: Colors.white.withOpacity(0.7),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: SizedBox(
                      width: 100.w,
                      height: 4.h+5.w,
                      child: Form(
                        key: formKey,
                        child: Row(
                          children: [
                            SizedBox(
                                width: 40.w,
                                child: Center(
                                  child: TextFormField(
                                    validator: (value) => value!.isEmpty
                                        ? "REQUIRED_FIELD".tr(context)
                                        : null,
                                    readOnly: true,
                                    controller: fromDateController,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(), //get today's date
                                          firstDate: DateTime(2000), //DateTime.now()
                                          lastDate: DateTime(2101)
                                      );

                                      if(pickedDate != null ){
                                        String formattedDate = date.DateFormat('dd-MM-yyyy').format(pickedDate);
                                        setState(() {
                                          fromDateController.text = formattedDate; //
                                        });
                                      }else{
                                        if (kDebugMode) {
                                          print("Date is not selected");
                                        }
                                      }

                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText:"PAYMENTS_PAGE_CHOOSE_DATE1".tr(context) ,
                                      hintStyle:TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,) ,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                    ),

                                  ),
                                )),
                            const VerticalDivider (width: 5,color: Colors.black,),
                            SizedBox(
                                width: 40.w,
                                child: Center(
                                  child: TextFormField(
                                    validator: (value) => value!.isEmpty
                                        ? "REQUIRED_FIELD".tr(context)
                                        : null,
                                    readOnly: true,
                                    controller: toDateController,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(), //get today's date
                                          firstDate: DateTime(2000), //DateTime.now()
                                          lastDate: DateTime(2101)
                                      );

                                      if(pickedDate != null ){
                                        String formattedDate = date.DateFormat('dd-MM-yyyy').format(pickedDate);

                                        setState(() {
                                          toDateController.text = formattedDate;
                                        });
                                      }else{
                                        if (kDebugMode) {
                                          print("Date is not selected");
                                        }
                                      }

                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText:"PAYMENTS_PAGE_CHOOSE_DATE2".tr(context) ,
                                      hintStyle:TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,) ,
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                    ),
                                  ),
                                )),
                            IconButton(onPressed: (){
                              if(formKey.currentState!.validate())
                              {
                                BlocProvider.of<ProductsBloc>(context).add(GetInvoicesEvent(widget.childId,widget.accessToken,fromDateController.text,toDateController.text));

                              }
                            }, icon: const Icon(Icons.search))
                          ],
                        ),
                      ),
                    ),),
                  SizedBox(height: 1.h,),
                  SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                          itemCount: state.invoices.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 10.h,
                                child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("INVOICE_DATE".tr(context),style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w700),),
                                          ),
                                          InkWell(
                                          onTap: (){
                                            BlocProvider.of<ProductsBloc>(context).add(GetHistoryProductsEvent(state.invoices[index].id!, widget.accessToken));
                                            Go.to(context, HistoryProductsPage(currency: widget.currencyName, childImage: widget.childImage, date: date.DateFormat('dd/MM/yyyy').format(DateTime.parse(state.invoices[index].date!)), invoiceNum: state.invoices[index].referenceCode!));
                                          },
                                          child:Card(
                                              elevation: 10,
                                              color: Colors.white.withOpacity(0.7),
                                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)) ,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(date.DateFormat('dd/MM/yyyy').format(DateTime.parse(state.invoices[index].date!)),style: TextStyle(color: Colors.red,fontSize: 14.sp,fontWeight: FontWeight.w600),),
                                              )),

                            )]),
                                );
                          }
                      ))
                ])));
      }
      else {
        return Scaffold(body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    image: AssetImage('assets/images/bg.png'))),
            child: const LoadingWidget()));
      }
    }
    );}
  }
