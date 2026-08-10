import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: colors.surface,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 16,
                      right: 16,
                    ),
                    child: Image.asset('assets/images/feedbackImage.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Your FeedBack',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Give your best time for this moment.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  _buildComposer(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: const Text('Send'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: TextField(
            maxLines: null,
            onChanged: (String txt) {},
            style: theme.textTheme.bodyLarge,
            cursorColor: colors.primary,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your feedback...',
            ),
          ),
        ),
      ),
    );
  }
}
