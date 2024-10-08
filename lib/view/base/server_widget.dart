import 'package:darkfire_vpn/common/navigation.dart';
import 'package:darkfire_vpn/controllers/vpn_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../screens/servers/servers.dart';
import '../screens/servers/widgets/servers_view.dart';

class SelectedServerWidget extends StatefulWidget {
  const SelectedServerWidget({super.key});

  @override
  State<SelectedServerWidget> createState() => _SelectedServerWidgetState();
}

class _SelectedServerWidgetState extends State<SelectedServerWidget> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnController>(builder: (vpnController) {
      var config = vpnController.vpnConfig;
      return Padding(
        padding: EdgeInsets.only(
          left: 16.sp,
          right: 16.sp,
          top: 32.sp,
          bottom: 50.sp,
        ),
        child: InkWell(
          onTap: () => launchScreen(const ServerScreen()),
          borderRadius: BorderRadius.circular(8.sp),
          child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.sp),
                boxShadow: boxShadow,
                border: Border.all(color: primaryColor, width: 0.75),
              ),
              child: ServerItem(server: config)),
        ),
      );
    });
  }
}
