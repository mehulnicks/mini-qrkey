import 'package:flutter/material.dart';

/// QRKEY Logo Widget
/// 
/// A reusable widget that displays the QRKEY logo with fallback options
class QRKeyLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? iconColor;
  final double iconSize;
  
  const QRKeyLogo({
    super.key,
    this.width,
    this.height,
    this.iconColor,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/qrkey_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to QR code icon if logo image fails to load
        return Icon(
          Icons.qr_code,
          size: iconSize,
          color: iconColor ?? Theme.of(context).primaryColor,
        );
      },
    );
  }
}

/// QRKEY App Title Widget
/// 
/// A reusable widget that displays the QRKEY app title
class QRKeyTitle extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  
  const QRKeyTitle({
    super.key,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'QRKEY',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}

/// QRKEY Logo with Title
/// 
/// A combination widget showing both logo and title
class QRKeyLogoWithTitle extends StatelessWidget {
  final double logoSize;
  final double titleSize;
  final Color? color;
  final MainAxisAlignment alignment;
  final bool isHorizontal;
  
  const QRKeyLogoWithTitle({
    super.key,
    this.logoSize = 60,
    this.titleSize = 24,
    this.color,
    this.alignment = MainAxisAlignment.center,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = [
      QRKeyLogo(
        width: logoSize,
        height: logoSize,
        iconColor: color,
        iconSize: logoSize * 0.8,
      ),
      SizedBox(
        width: isHorizontal ? 12 : 0,
        height: isHorizontal ? 0 : 8,
      ),
      QRKeyTitle(
        fontSize: titleSize,
        color: color,
      ),
    ];

    return isHorizontal
        ? Row(
            mainAxisAlignment: alignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgets,
          )
        : Column(
            mainAxisAlignment: alignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgets,
          );
  }
}
