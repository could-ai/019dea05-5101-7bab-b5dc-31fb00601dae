import 'package:flutter/material.dart';

enum DealStage { lead, qualified, proposal, negotiation, won, lost }

class Contact {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final String avatarUrl;

  const Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.avatarUrl,
  });
}

class Deal {
  final String id;
  final String title;
  final String company;
  final double value;
  final DealStage stage;
  final DateTime expectedCloseDate;
  final String contactId;

  const Deal({
    required this.id,
    required this.title,
    required this.company,
    required this.value,
    required this.stage,
    required this.expectedCloseDate,
    required this.contactId,
  });
}

class Activity {
  final String id;
  final String title;
  final String type; // e.g., 'call', 'email', 'meeting'
  final DateTime date;
  final String contactId;

  const Activity({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.contactId,
  });
}

// Mock Data
class MockData {
  static final List<Contact> contacts = [
    const Contact(id: 'c1', name: 'Alice Smith', email: 'alice@acme.com', phone: '555-0101', company: 'Acme Corp', avatarUrl: 'https://i.pravatar.cc/150?u=c1'),
    const Contact(id: 'c2', name: 'Bob Johnson', email: 'bob@globex.com', phone: '555-0102', company: 'Globex', avatarUrl: 'https://i.pravatar.cc/150?u=c2'),
    const Contact(id: 'c3', name: 'Charlie Davis', email: 'charlie@initech.com', phone: '555-0103', company: 'Initech', avatarUrl: 'https://i.pravatar.cc/150?u=c3'),
    const Contact(id: 'c4', name: 'Diana Evans', email: 'diana@soylent.com', phone: '555-0104', company: 'Soylent', avatarUrl: 'https://i.pravatar.cc/150?u=c4'),
    const Contact(id: 'c5', name: 'Evan Wright', email: 'evan@massive.com', phone: '555-0105', company: 'Massive Dynamic', avatarUrl: 'https://i.pravatar.cc/150?u=c5'),
  ];

  static final List<Deal> deals = [
    Deal(id: 'd1', title: 'Acme Software License', company: 'Acme Corp', value: 15000, stage: DealStage.qualified, expectedCloseDate: DateTime.now().add(const Duration(days: 15)), contactId: 'c1'),
    Deal(id: 'd2', title: 'Globex Cloud Migration', company: 'Globex', value: 45000, stage: DealStage.proposal, expectedCloseDate: DateTime.now().add(const Duration(days: 30)), contactId: 'c2'),
    Deal(id: 'd3', title: 'Initech Support Contract', company: 'Initech', value: 8000, stage: DealStage.lead, expectedCloseDate: DateTime.now().add(const Duration(days: 45)), contactId: 'c3'),
    Deal(id: 'd4', title: 'Soylent R&D Tools', company: 'Soylent', value: 120000, stage: DealStage.negotiation, expectedCloseDate: DateTime.now().add(const Duration(days: 5)), contactId: 'c4'),
    Deal(id: 'd5', title: 'Acme Expansion', company: 'Acme Corp', value: 25000, stage: DealStage.won, expectedCloseDate: DateTime.now().subtract(const Duration(days: 10)), contactId: 'c1'),
    Deal(id: 'd6', title: 'Globex Hardware', company: 'Globex', value: 9000, stage: DealStage.lost, expectedCloseDate: DateTime.now().subtract(const Duration(days: 20)), contactId: 'c2'),
  ];

  static final List<Activity> activities = [
    Activity(id: 'a1', title: 'Initial discovery call', type: 'call', date: DateTime.now().subtract(const Duration(hours: 2)), contactId: 'c1'),
    Activity(id: 'a2', title: 'Sent proposal PDF', type: 'email', date: DateTime.now().subtract(const Duration(days: 1)), contactId: 'c2'),
    Activity(id: 'a3', title: 'Lunch meeting', type: 'meeting', date: DateTime.now().add(const Duration(days: 1)), contactId: 'c4'),
    Activity(id: 'a4', title: 'Follow-up on terms', type: 'call', date: DateTime.now().subtract(const Duration(hours: 5)), contactId: 'c4'),
  ];
}
