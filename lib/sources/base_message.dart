import 'package:flutter/material.dart';

/// AppError or AppMessage should extend to this class for localization
abstract class BaseMessage {
  String localized(BuildContext context);
}
