import 'package:flutter/material.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({super.key});

  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerInviteFriend),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Image.asset('assets/images/inviteImage.png'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Invite Your Friends',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Are you one of those who makes everything\n at the last moment?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      debugPrint('Share Action.');
                    },
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Share'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
