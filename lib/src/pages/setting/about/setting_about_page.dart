import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/consts/jh_consts.dart';
import 'package:jhentai/src/extension/widget_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingAboutPage extends StatefulWidget {
  const SettingAboutPage({Key? key}) : super(key: key);

  @override
  _SettingAboutPageState createState() => _SettingAboutPageState();
}

class _SettingAboutPageState extends State<SettingAboutPage> {
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  String author = '酱天小禽兽(JTMonster)';
  String gitRepo = 'https://github.com/jiangtian616/JHenTai';
  String helpPage = 'https://github.com/jiangtian616/JHenTai/wiki';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      if (!mounted) {
        return;
      }
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('JHenTai-ohos')),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          ListTile(title: Text('version'.tr), subtitle: Text(version.isEmpty ? '1.0.0' : version + (buildNumber.isEmpty ? '' : '+$buildNumber'))),
          ListTile(title: Text('author'.tr), subtitle: SelectableText(author)),
          ListTile(title: Text('portedBy'.tr), subtitle: const SelectableText('ceiba4687')),
          ListTile(
            title: const Text('GitHub (JHenTai-ohos)'),
            subtitle: const SelectableText(JHConsts.repositoryUrl),
            onTap: () => launchUrlString(JHConsts.repositoryUrl, mode: LaunchMode.externalApplication),
          ),
          ListTile(
            title: const Text('GitHub (JHenTai)'),
            subtitle: SelectableText(gitRepo),
            onTap: () => launchUrlString(gitRepo, mode: LaunchMode.externalApplication),
          ),
          ListTile(
            title: Text('Q&A'.tr),
            subtitle: SelectableText(helpPage),
            onTap: () => launchUrlString(helpPage, mode: LaunchMode.externalApplication),
          ),
        ],
      ).withListTileTheme(context),
    );
  }
}
