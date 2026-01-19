class AutoLaunch {
  Future<void> setup({required String appName, required String appPath}) async {}
  Future<bool> isEnabled() async => false;
  Future<void> enable() async {}
  Future<void> disable() async {}
}

final AutoLaunch launchAtStartup = AutoLaunch();
