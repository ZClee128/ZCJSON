//
//  CodableProtocol.swift
//  ZCJSON
//
//  Created by lzc on 2022/6/27.
//
import Foundation

public protocol CaseDefaultsFirst: Encodable & Decodable & CaseIterable & RawRepresentable where RawValue: Decodable, AllCases: BidirectionalCollection {}

public extension CaseDefaultsFirst {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.first!
    }
}
