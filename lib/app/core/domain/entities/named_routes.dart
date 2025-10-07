enum NamedRoutes {
  splash('/'),
  mainNavigator('/main-navigator'),
  home('/home'),
  timer('/timer'),
  allRecordsByGroup('/all-records-by-group'),
  config('/config'),
  settings('/settings'),
  subscriptions('/subscriptions');

  final String route;
  const NamedRoutes(this.route);
}
