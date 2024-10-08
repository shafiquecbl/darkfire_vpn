import 'dart:convert';
import 'package:darkfire_vpn/common/snackbar.dart';
import 'package:darkfire_vpn/data/model/response/ip_address.dart';
import 'package:darkfire_vpn/data/repository/server_repo.dart';
import 'package:get/get.dart';
import '../data/model/body/vpn_config.dart';

class ServerController extends GetxController implements GetxService {
  final ServerRepo serverRepo;
  ServerController({required this.serverRepo});
  static ServerController get find => Get.find<ServerController>();

  static ServerController get to => Get.find<ServerController>();

  bool _loading = false;
  List<VpnConfig> _allServers = [];
  IpAddressModel? _publicIP;
  int _currentIndex = 0;

  bool get loading => _loading;
  List<VpnConfig> get allServers => _allServers;
  IpAddressModel? get publicIP => _publicIP;
  int get currentIndex => _currentIndex;

  set publicIP(IpAddressModel? value) {
    _publicIP = value;
    update();
  }

  set loading(bool value) {
    _loading = value;
    update();
  }

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }

  Future<void> getAllServers() async {
    loading = true;
    final response = await serverRepo.getAllServers();
    if (response != null) {
      final data = jsonDecode(response.body)['data'];
      _allServers =
          List<VpnConfig>.from(data.map((x) => VpnConfig.fromJson(x)));
      serverRepo.saveServers(value: _allServers);
      loading = false;
    }
  }

  Future<void> getAllServersFromCache() async {
    _allServers = serverRepo.loadServers();
    update();
  }

  Future<VpnConfig?> getServerDetails(String server) async {
    showLoading();
    final response = await serverRepo.getServerDetail(server);
    if (response != null) {
      final data = jsonDecode(response.body)['data'];
      return VpnConfig.fromJson(data);
    }
    return null;
  }

  Future<VpnConfig> getRandomServer() async {
    final response = await serverRepo.getRandomServer();
    VpnConfig? randomServer;
    if (response != null) {
      final data = jsonDecode(response.body)['data'];
      randomServer = VpnConfig.fromJson(data);
    }
    return randomServer!;
  }

  // Future<void> getPublicIP() async {
  //   final response = await serverRepo.getPublicIP();
  //   if (response != null) {
  //     final data = jsonDecode(response.body);
  //     publicIP = IpAddressModel.fromJson(data);
  //   }
  // }
}
