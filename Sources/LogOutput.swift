//
//  LogOutput.swift
//  PersonalLib
//
//  Created by Kojirou on 2016/11/28.
//
//

import Foundation

public func printLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
	#if DEBUG
		print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
	#endif
}
