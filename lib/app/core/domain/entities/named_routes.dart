enum NamedRoutes {
  splash('/'),
  home('/home'),
  timer('/timer'),
  config('/config');

  final String route;
  const NamedRoutes(this.route);
}
