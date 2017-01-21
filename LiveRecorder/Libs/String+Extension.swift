//
//  String+Extension.swift
//  PersonalLib
//
//  Created by Kojirou on 2016/11/28.
//
//

import Foundation

extension String {
	
	public subscript(bounds: Range<Int>) -> String {
		return self[index(startIndex, offsetBy: bounds.lowerBound)..<index(startIndex, offsetBy: bounds.upperBound)]
	}
	
	public subscript(i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}
	
	public subscript(bounds: ClosedRange<Int>) -> String {
		return self[index(startIndex, offsetBy: bounds.lowerBound)...index(startIndex, offsetBy: bounds.upperBound)]
	}
}
