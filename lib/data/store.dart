import 'package:flutter/cupertino.dart';
import 'package:matika/view/widget/time_remaining_text.dart';

class Store {
  String name;
  IconData icon; // とりあえずiconを設置するが理想は画像
  RemainingType type;
  String state;

//<editor-fold desc="Data Methods">

  Store({
    required this.name,
    required this.icon,
    required this.type,
    required this.state,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          icon == other.icon &&
          type == other.type &&
          state == other.state);

  @override
  int get hashCode =>
      name.hashCode ^ icon.hashCode ^ type.hashCode ^ state.hashCode;

  @override
  String toString() {
    return 'Store{ name: $name, icon: $icon, type: $type, state: $state,}';
  }

  Store copyWith({
    String? name,
    IconData? icon,
    RemainingType? type,
    String? state,
  }) {
    return Store(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'icon': this.icon,
      'type': this.type,
      'state': this.state,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      name: map['name'] as String,
      icon: map['icon'] as IconData,
      type: map['type'] as RemainingType,
      state: map['state'] as String,
    );
  }

//</editor-fold>
}