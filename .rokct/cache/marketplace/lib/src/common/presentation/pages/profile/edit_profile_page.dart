// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// The customer edit-own-details sheet was PROMOTED verbatim to base_sdk
// (1.45.0, approved frame 4d 2026-08-30 — chips 725-734) so every
// GenericProfilePage host can wire the user-card pencil (chip 109,
// ProfileSectionRegistry.I.onEditProfile) to the one shipped flow — the
// manager hub is the first new consumer. This file stays as the
// marketplace call-sites' import path (my_account.dart's "Edit account"
// row) and re-exports the shared component; customer behavior is
// unchanged — same class name, same `EditProfileScreen(controller: c)`
// drag-sheet contract, same base_sdk editProfileProvider save path.
export 'package:base_sdk/src/presentation/pages/profile/edit_profile_sheet.dart'
    show EditProfileScreen;
