import 'package:darkfire_vpn/common/primary_button.dart';
import 'package:darkfire_vpn/controllers/time_controller.dart';
import 'package:darkfire_vpn/controllers/vpn_controller.dart';
import 'package:darkfire_vpn/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../helper/vpn_helper.dart';
import '../../../../utils/style.dart';
import '../../../base/ad_loading_dialog.dart';
import '../../../base/speed_widget.dart';
import 'disconnect_sheet.dart';

class ConnectedView extends StatefulWidget {
  const ConnectedView({super.key});

  @override
  State<ConnectedView> createState() => _ConnectedViewState();
}

class _ConnectedViewState extends State<ConnectedView> {
  @override
  void initState() {
    // ServerController.find.getPublicIP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: pagePadding,
            child: const ConnectedDetails(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: pagePadding,
              child: const PrimaryButton(
                text: 'disconnect',
                onPressed: showDisconnectSheet,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ConnectedDetails extends StatelessWidget {
  const ConnectedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnController>(builder: (vpnController) {
      //
      double bytein = 0;
      double byteout = 0;
      if ((vpnController.vpnStatus?.byteIn?.trim().isEmpty ?? false) ||
          vpnController.vpnStatus?.byteIn == "0") {
        bytein = 0;
      } else {
        bytein =
            double.tryParse(vpnController.vpnStatus!.byteIn.toString()) ?? 0;
      }

      if ((vpnController.vpnStatus?.byteOut?.trim().isEmpty ?? false) ||
          vpnController.vpnStatus?.byteIn == "0") {
        byteout = 0;
      } else {
        byteout =
            double.tryParse(vpnController.vpnStatus!.byteOut.toString()) ?? 0;
      }
      return Column(
        children: [
          // you are protected
          Container(
            margin: EdgeInsets.only(bottom: 32.sp),
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.shield_tick, size: 20.sp, color: primaryColor),
                SizedBox(width: 5.sp),
                Text(
                  'you_are_now_protected'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: primaryColor),
                )
              ],
            ),
          ),

          // Connection Time
          Text(
            vpnController.remainingTime,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 54.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
          ),
          SizedBox(height: 5.sp),
          // ip address,
          Text(
            vpnController.vpnConfig?.serverIp ?? 'loading'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          SizedBox(height: 16.sp),

          // Speed,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SpeedWidget(
                title: 'download'.tr,
                icon: Iconsax.arrow_down,
                iconColor: Colors.blue,
                speed: "${formatBytes(bytein.floor(), 2)}/s",
              )),
              // divider,
              Container(
                width: 2,
                height: 30.sp,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                child: SpeedWidget(
                  title: 'upload'.tr,
                  icon: Iconsax.arrow_up_3,
                  iconColor: Colors.purple,
                  speed: "${formatBytes(byteout.floor(), 0)}/s",
                ),
              )
            ],
          ),
          SizedBox(height: 24.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150.sp,
                child: PrimaryButton(
                  text: '+1 ${'hour'.tr}',
                  onPressed: () =>
                      Get.dialog(const AdLoadingDialog(hour: true)),
                ),
              ),
              SizedBox(
                width: 150.sp,
                child: PrimaryButton(
                  color: primaryColor.withOpacity(0.15),
                  textColor: primaryColor,
                  text: 'extra_time'.tr,
                  onPressed: _addAddTime,
                ),
              ),
            ],
          )
        ],
      );
    });
  }

  _addAddTime() {
    if (TimeController.find.canAvailExtraTime()) {
      Get.dialog(const AdLoadingDialog());
    } else {
      Get.dialog(const EnoughTimeDialog());
    }
  }
}
