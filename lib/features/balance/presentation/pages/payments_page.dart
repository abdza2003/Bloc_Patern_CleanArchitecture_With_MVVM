import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/features/account/domain/entities/child.dart';
import 'package:school_cafteria/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/network/api.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key, required this.studentIds, required this.children}) : super(key: key);
  final List<int> studentIds;
  final List<Child> children;
  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fromDateController.text = ""; //set the initial value of text field
    toDateController.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BalanceBloc, BalanceState>(
        listener: (context, state) {
          if (state is ErrorMsgState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is SuccessCancelMsgState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            if(fromDateController.text.isNotEmpty) {
              BlocProvider.of<BalanceBloc>(context).add(GetPaymentsEvent(widget.studentIds,fromDateController.text,toDateController.text));
            }
            else
              {
                BlocProvider.of<BalanceBloc>(context).add(GetPaymentsEvent(widget.studentIds,null,null));

              }
          }
        }, buildWhen: (balanceBloc, balanceState) {
      if (balanceState is LoadedPaymentsState) {
        return true;
      } else {
        return false;
      }
    }, builder: (context,
        state,) {
      if (state is LoadingState) {
        return const LoadingWidget();
      } else if (state is LoadedPaymentsState) {
        return ListView(children: [
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
                                     firstDate: DateTime(2000),
                                     lastDate: DateTime(2028)
                                 );

                                 if(pickedDate != null ){
                                   String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                   setState(() {
                                     fromDateController.text = formattedDate;
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
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2028)
                          );

                          if(pickedDate != null ){
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
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
                             BlocProvider.of<BalanceBloc>(context).add(GetPaymentsEvent(widget.studentIds,fromDateController.text,toDateController.text));

                           }
                       }, icon: const Icon(Icons.search))
                    ],
                  ),
                ),
              ),),
              SizedBox(height: 2.h,),
              Center(child: Text("PAYMENTS_PAGE_TOTAL_SPENT".tr(context)+state.payments.totalSpent,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w700),),),
              SizedBox(
                  height: 100.h,
                  child: state.payments.userBalances!.isEmpty
      ? const SizedBox()
          : ListView.builder(
                      itemCount: state.payments.userBalances!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                            height: 7.h + 23.w,
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                state.payments.userBalances![index]
                                              .child!.image ==
                                              null
                                              ? Image.asset(
                                            'assets/launcher/logo.png',
                                            scale: 15.0,
                                          )
                                              :Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          25.0),
                                      border: Border.all(color: primaryColor)),
                                  height: 12.h+13.w,
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          25.0),
                                      child:Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            Network()
                                                  .baseUrl +
                                                  state.payments.userBalances![index]
                                                      .child!.image!),
                                        width: 35.w,
                                      )),
                                ),
                                              ),
                                Column(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width:57.w,
                                        child: Text(state.payments.userBalances![index].typeName!,textAlign: TextAlign.end,style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w700),)),
                        Card(
                          color: Colors.white.withOpacity(0.7),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                          child: SizedBox(
                            width: 57.w,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                              Padding(
                                padding: const EdgeInsets.only(top:10.0 ,bottom: 10.0),
                                child: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(state.payments.userBalances![index].createdAt!)),style: const TextStyle(fontWeight: FontWeight.w700),),
                              ),
                              Text(toCurrencyString(state.payments.userBalances![index].balanceValue!,trailingSymbol:state.payments.userBalances![index].child!.school!.currencyName! ,useSymbolPadding: true),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp,color: const Color(0xff209138) ),)
                            ],),
                          )),
                                    SizedBox(
                                        width:57.w,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: 0.w,),
                                            Text("PAYMENTS_PAGE_STATUS".tr(context)+state.payments.userBalances![index].statusName!,style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.w700),),
                                            _getWidget(state.payments.userBalances![index].status!,state.payments.userBalances![index].id!,state.payments.userBalances![index].child!.id!)
                                          ],
                                        )),


                                  ],
                                )

                              ],));
                      }))
            ]);
      }
      else {
        return const LoadingWidget();
      }
    });
  }

  Widget _getWidget(String status,int requestId,int childId) {
    if(status=="1")
      {
        return InkWell(
          onTap: (){
            String accessToken=widget.children.where((element) => element.id==childId).first.accessTokenParent!;
            confirmationDialog(context,(){BlocProvider.of<BalanceBloc>(context).add(CancelBalanceEvent(requestId, accessToken));},"PAYMENTS_PAGE_CONFIRMATION_CANCEL".tr(context));

          },
          child: Row(
            children: [
              Text("DIALOG_BUTTON_CANCEL".tr(context),style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.w700)),
              const Icon(Icons.cancel,color: Colors.red,),
            ],
          ),
        );
      }
    else if (status=="3")
      {
        return const SizedBox();
      }
    else
      {
        return const SizedBox();
      }
  }
}