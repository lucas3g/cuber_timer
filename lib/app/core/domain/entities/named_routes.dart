enum NamedRoutes {
  splash('/'),
  home('/home'),
  timer('/timer'),
  allRecordsByGroup('/all-records-by-group'),
  config('/config');

  final String route;
  const NamedRoutes(this.route);
}
