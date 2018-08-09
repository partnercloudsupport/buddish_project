import 'package:buddish_project/constants.dart';
import 'package:meta/meta.dart';

class Mantra {
  final String name;
  final String url;
  final bool isPlaying;

  Mantra({
    @required this.name,
    @required this.url,
    @required this.isPlaying,
  });

  Mantra copyWith({
    String name,
    String url,
    bool isPlaying,
  }) {
    return Mantra(
      name: name ?? this.name,
      url: url ?? this.url,
      isPlaying: isPlaying ?? isPlaying,
    );
  }

  static List<Mantra> generate() {
    return [
      Mantra(name: 'สวดมนต์ทำวัดเช้า', url: Asset.audio1, isPlaying: false),
      Mantra(name: 'สวดมนต์ทำวัดเย็น', url: Asset.audio2, isPlaying: false),
      Mantra(name: 'สวดมนต์ประจำวัน', url: Asset.audio3, isPlaying: false),
      Mantra(name: 'สวดมนต์ก่อนนอน', url: Asset.audio4, isPlaying: false),
      Mantra(name: 'สวดมนต์แผ่เมตตรา', url: Asset.audio5, isPlaying: false),
    ];
  }
}