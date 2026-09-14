/// One row in the shell list, before we've actually downloaded that
/// shell's content. Kept minimal on purpose — just enough to show a list
/// and then go fetch the rest.
class ShellDescriptor {
  final String id;
  final String idShort;

  const ShellDescriptor({required this.id, required this.idShort});

  @override
  String toString() => 'ShellDescriptor($idShort, $id)';
}
