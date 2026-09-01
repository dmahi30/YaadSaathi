class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final String photoUrl;
  final String voiceLineText;
  final String? audioPath;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.photoUrl,
    required this.voiceLineText,
    this.audioPath,
  });
}