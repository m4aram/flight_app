enum CabinClass {
  economy('Economy'),
  premiumEconomy('Premium Economy'),
  business('Business'),
  first('First');

  const CabinClass(this.label);

  final String label;
}
