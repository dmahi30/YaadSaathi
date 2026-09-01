import '../models/family_member.dart';

final List<FamilyMember> fakeFamilyMembers = [
  FamilyMember(
    id: '1',
    name: 'Meera',
    relation: 'Daughter',
    photoUrl: 'assets/images/characters/meera.jpeg',
    voiceLineText: "Hi Amma, it's Meera, your daughter.",
  ),

  FamilyMember(
    id: '2',
    name: 'Rahul',
    relation: 'Son',
    photoUrl: 'assets/images/characters/rahul.jpeg',
    voiceLineText: "Hey, it's Rahul, your son.",
  ),

  FamilyMember(
    id: '3',
    name: 'Asha',
    relation: 'Sister',
    photoUrl: 'assets/images/characters/asha.jpeg',
    voiceLineText: "Hi, it's Asha, your sister.",
  ),

  FamilyMember(
    id: '4',
    name: 'Uncle Arun',
    relation: 'Brother',
    photoUrl: 'assets/images/characters/arun.jpeg',
    voiceLineText: "Hello, it's Arun, your brother.",
  ),

  FamilyMember(
    id: '5',
    name: 'Dadi (Mother)',
    relation: 'Mother',
    photoUrl: 'assets/images/characters/dadi.jpeg',
    voiceLineText: "It's Amma, your mother.",
  ),
];