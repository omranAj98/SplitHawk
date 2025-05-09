part of '../account_screen.dart';

class QrSection extends StatelessWidget {
  const QrSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          // decoration: BoxDecoration(shape: BoxShape.circle),
          child: GestureDetector(
            onTap: () {
              dialogQRCode(context);
            },
            child: Image.asset(
              "assets/images/qr-code.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          label: Text(AppLocalizations.of(context)!.scanYourFriendQrCode),
          icon: const Icon(Icons.qr_code_scanner),
        ),
      ],
    );
  }
}
