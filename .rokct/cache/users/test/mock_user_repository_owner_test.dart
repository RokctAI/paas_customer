// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

// The demo profile is what every shell's account still shows. It must read
// like a real person (no Demo / example / placeholder wording reaches a
// screenshot), must not invent a role the sign-in address did not
// establish, and must agree with the address book on the home address.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:base_sdk/src/models/data/profile_data.dart';
import 'package:base_sdk/src/models/response/profile_response.dart';
import 'package:base_sdk/src/services/local_storage.dart';

import 'package:users_sdk/src/common/infrastructure/repositories/mock_user_repository.dart';

// Each demo account (one per role) gets its own profile: the partner and
// admin demo accounts used to read Thandi's, id included, so all three
// shared one owner scope (Ray, 2026-09-23).
Future<ProfileData> _fetch(MockUserRepository repo) async {
  final result = await repo.getProfileDetails();
  return (result as Success<ProfileResponse>).data.data!;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  test('a partner demo session reads its own profile, not Thandi', () async {
    final repo = MockUserRepository();
    await LocalStorage.setUser(ProfileData(
      id: '2',
      firstname: 'Nomvula',
      lastname: 'Mokoena',
      email: 'nomvula.mokoena@outlook.com',
      role: 'partner',
    ));
    final partner = await _fetch(repo);
    expect(partner.id, '2');
    expect(partner.firstname, 'Nomvula');
    expect(partner.role, 'partner');

    await LocalStorage.setUser(ProfileData(
      id: '1',
      email: 'thandi.mokoena@outlook.com',
      role: 'customer',
    ));
    final student = await _fetch(repo);
    expect(student.id, '1');
    expect(student.firstname, 'Thandi');
    expect(student.role, 'customer');
  });

  test('profile edits stay with the account that made them', () async {
    final repo = MockUserRepository();
    await LocalStorage.setUser(ProfileData(id: '3', firstname: 'Ayanda'));
    await repo.updateProfileImage(firstName: 'Ayo', imageUrl: 'x');
    expect((await _fetch(repo)).firstname, 'Ayo');

    await LocalStorage.setUser(ProfileData(id: '1'));
    expect((await _fetch(repo)).firstname, 'Thandi');
  });
}
