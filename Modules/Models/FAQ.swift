// FAQ.swift
// Copyright (C) 2020 Presidenza del Consiglio dei Ministri.
// Please refer to the AUTHORS file for more information.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import Foundation

/// A struct representing an FAQ
public struct FAQ: Equatable, Codable {
  /// The title of the FAQ
  public let title: String

  /// The content of the FAQ
  public let content: String

  /// Creates a new FAQ
  public init(title: String, content: String) {
    self.title = title
    self.content = content
  }
}

// MARK: Italian default FAQs

public extension FAQ {
  static let italianDefaultValues: [FAQ] = [
    .init(title: "[IT] Domanda", content: "[EN] Questa é una risposta")
  ]
}

// MARK: English default FAQs

public extension FAQ {
  static let englishDefaultValues: [FAQ] = [
    .init(title: "[EN] Domanda", content: "[EN] Questa é una risposta")
  ]
}

// MARK: German default FAQs

public extension FAQ {
  static let germanDefaultValues: [FAQ] = [
    .init(title: "[DE] Domanda", content: "[DE] Questa é una risposta")
  ]
}
