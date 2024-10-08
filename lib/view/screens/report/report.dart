import 'package:cached_network_image/cached_network_image.dart';
import 'package:darkfire_vpn/controllers/review_controller.dart';
import 'package:darkfire_vpn/controllers/vpn_controller.dart';
import 'package:darkfire_vpn/data/model/body/vpn_config.dart';
import 'package:darkfire_vpn/utils/colors.dart';
import 'package:darkfire_vpn/view/base/appBar.dart';
import 'package:darkfire_vpn/view/base/speed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../../../helper/vpn_helper.dart';
import '../../../utils/style.dart';
import '../../base/map_background.dart';
import '../../base/rating_widget.dart';

class ReportScreen extends StatefulWidget {
  final VpnStatus vpnStatus;
  final VpnConfig vpnConfig;
  const ReportScreen(
      {required this.vpnStatus, required this.vpnConfig, super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ReviewController.find.checkReviewed();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnController>(builder: (vpnController) {
      //
      double bytein = 0;
      double byteout = 0;
      if ((widget.vpnStatus.byteIn?.trim().isEmpty ?? false) ||
          widget.vpnStatus.byteIn == "0") {
        bytein = 0;
      } else {
        bytein = double.tryParse(widget.vpnStatus.byteIn.toString()) ?? 0;
      }

      if ((widget.vpnStatus.byteOut?.trim().isEmpty ?? false) ||
          widget.vpnStatus.byteIn == "0") {
        byteout = 0;
      } else {
        byteout = double.tryParse(widget.vpnStatus.byteOut.toString()) ?? 0;
      }
      return Scaffold(
        body: Stack(
          children: [
            const MapBackground(),
            Column(
              children: [
                CustomAppBar(text: 'report'.tr),
                Expanded(
                  child: ListView(
                    padding: pagePadding,
                    children: [
                      SizedBox(height: 32.sp),
                      Center(
                        child: CircleAvatar(
                          radius: 30.sp,
                          backgroundColor: primaryColor,
                          backgroundImage:
                              widget.vpnConfig.flag.contains("http")
                                  ? CachedNetworkImageProvider(
                                      widget.vpnConfig.flag)
                                  : null,
                          child: widget.vpnConfig.flag.contains("http")
                              ? null
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(32.sp),
                                  child: Image.asset(
                                    "icons/flags/png/${widget.vpnConfig.flag}.png",
                                    package: "country_icons",
                                    width: 18.sp,
                                    height: 18.sp,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 50.sp),
                      // Connection Time
                      Center(
                        child: Text(
                          widget.vpnStatus.duration ?? "00:00:00",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 54.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                        ),
                      ),
                      SizedBox(height: 5.sp),
                      // ip address,
                      Center(
                        child: Text(
                          widget.vpnConfig.serverIp,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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
                      ReportStatItem(
                        icon: Iconsax.shield,
                        title: "protocol".tr,
                        value:
                            widget.vpnConfig.protocol?.toUpperCase() ?? "UDP",
                      ),
                      ReportStatItem(
                        icon: Iconsax.wifi,
                        title: "server".tr,
                        value: widget.vpnConfig.country,
                      ),
                      ReportStatItem(
                        icon: Iconsax.calendar,
                        title: "connected_on".tr,
                        value: DateFormat("dd MMM yyyy hh:mm a").format(
                            widget.vpnStatus.connectedOn ?? DateTime.now()),
                      ),
                      ReportStatItem(
                        icon: Iconsax.clock,
                        title: "conection_duration".tr,
                        value: formatDuration(
                            widget.vpnStatus.duration ?? "00:00:00"),
                      ),
                      SizedBox(height: 32.sp),
                      GetBuilder<ReviewController>(builder: (con) {
                        return Visibility(
                          visible: con.isReviewed == false,
                          child: const RatingWidget(),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  String formatDuration(String duration) {
    List<String> parts = duration.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    String formattedDuration = '';

    if (hours > 0) {
      formattedDuration += '${hours}h ';
    }
    if (minutes > 0) {
      formattedDuration += '${minutes}m ';
    }
    if (seconds > 0) {
      formattedDuration += '${seconds}s';
    }

    // Trim any trailing whitespace and return the result
    return formattedDuration.trim();
  }
}

class ReportStatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const ReportStatItem(
      {required this.icon,
      required this.title,
      required this.value,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp).copyWith(top: 20.sp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 16.sp),
          SizedBox(width: 10.sp),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
