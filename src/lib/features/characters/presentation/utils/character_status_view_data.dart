import 'package:flutter/material.dart';

Color characterStatusColor(String? status) {
  return switch (status?.toLowerCase()) {
    'alive' => Colors.green,
    'dead' => Colors.red,
    _ => Colors.grey,
  };
}

String characterStatusText(String? status) {
  return switch (status?.toLowerCase()) {
    'alive' => 'Alive',
    'dead' => 'Dead',
    _ => 'Unknown',
  };
}
