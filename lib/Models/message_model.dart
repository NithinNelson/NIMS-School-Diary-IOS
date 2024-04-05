

class Message {
  final int id;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;

  const Message({required this.id, required this.content, required this.sentTime, required this.messageType});
}

enum MessageType {
  text,
  image,
  audio,
  other;
}

enum ChatField {
  textField,
  audioRecording,
  audioPlaying;
}