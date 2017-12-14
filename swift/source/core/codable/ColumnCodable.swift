/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

public protocol ColumnCodableBase {
    static var columnType: ColumnType {get}
}

public protocol ColumnEncodableBase: Encodable, ColumnCodableBase {
    func archivedFundamentalValue() -> FundamentalColumnType?
}
public protocol ColumnEncodable: ColumnEncodableBase, LiteralValueConvertible {
    associatedtype FundamentalType: FundamentalColumnType
    func archivedValue() -> FundamentalType?
}
extension ColumnEncodable {
    public static var columnType: ColumnType {
        return FundamentalType.columnType
    }
    public func archivedFundamentalValue() -> FundamentalColumnType? {
        return archivedValue()
    }
    public func asLiteralValue() -> LiteralValue {
        return LiteralValue(self)
    }
}

public protocol ColumnDecodableBase: Decodable, ColumnCodableBase {
    init?(with value: FundamentalColumnType)
}
public protocol ColumnDecodable: ColumnDecodableBase {
    associatedtype FundamentalType: FundamentalColumnType
    init?(with value: FundamentalType)
}
extension ColumnDecodable {
    public static var columnType: ColumnType {
        return FundamentalType.columnType
    }
    public init?(with value: FundamentalColumnType) {
        guard let typedValue = value as? FundamentalType else {
            return nil
        }
        self.init(with: typedValue)
    }
}

public protocol ColumnCodable: ColumnEncodable, ColumnDecodable {}
extension ColumnCodable {
    public static var columnType: ColumnType {
        return FundamentalType.columnType
    }
}
