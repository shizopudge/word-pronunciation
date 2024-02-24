/// Статус сервиса произношения слов
enum SpeachServiceStatus {
  listening,
  notListening,
  done,
  unknown;

  factory SpeachServiceStatus.fromString(String status) {
    if (status == 'listening') {
      return SpeachServiceStatus.listening;
    } else if (status == 'notListening') {
      return SpeachServiceStatus.notListening;
    } else if (status == 'done') {
      return SpeachServiceStatus.done;
    }
    return SpeachServiceStatus.unknown;
  }
}
