/// One entry in the shell "menu" — the list [BasyxRepository.fetchShellList]
/// returns, before any of a shell's actual submodel content is downloaded.
/// Deliberately minimal (just enough to show something in a list and to
/// then ask for the full package): both the mock and the real BaSyx REST
/// API can produce this from very different underlying data without either
/// leaking into the other.
class ShellDescriptor {
  final String id;
  final String idShort;

  const ShellDescriptor({required this.id, required this.idShort});

  @override
  String toString() => 'ShellDescriptor($idShort, $id)';
}
