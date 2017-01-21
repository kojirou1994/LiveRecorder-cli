//
//  LiveStreamer.swift
//  LiveRecorder
//
//  Created by 王宇 on 2017/1/17.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Foundation

public final class LiveStreamer: JSONDeserializable {
	
	var name: String
	
	var roomId: Int
	
	var website: LiveWebsite
	
	var autoRecord: Bool
	
	var downloading: Bool = false
	
	var process: Process?
	
	required public init(jsonRepresentation json: JSONDictionary) throws {
		name = try decode(json, key: "name")
		roomId = try decode(json, key: "roomId")
		let website: String = try decode(json, key: "website")
		self.website = LiveWebsite(rawValue: website)!
		if let autoRecord: Bool = try? decode(json, key: "autoRecord") {
			self.autoRecord = autoRecord
		} else {
			self.autoRecord = true
		}
	}
	
	var url: String {
		return website.fullUrl + String(roomId)
	}
	
	var filename: String {
		let format = DateFormatter()
		format.dateFormat = "yyyyMMddHHmmss"
		let time = format.string(from: Date())
		return "\(name)-\(time).\(website.fileSuffix)"
	}
	
	public func record(force: Bool = false, autoRetry: Bool = false, location: String = "/Volumes/Otoko/Live_Recording") {
		guard !downloading else {
			print("\(name) is already recording.")
			return
		}
		guard force || autoRecord else {
			print("\(name) not recording by rule.")
			return
		}
		downloading = true
		process = Process()
		process?.launchPath = "/bin/zsh"
		process?.arguments = ["-c", "/usr/local/bin/livestreamer -v \(url) source -o \(location)/\(filename)"]
		process?.standardError = nil
		process?.standardOutput = nil
		if autoRetry {
			process?.terminationHandler = { proc in
				print(proc.terminationStatus)
				self.downloading = false
				print("Recording \(self.name) finished. Auto retry...")
				self.record(force: true)
				self.process = nil
			}
		} else {
			process?.terminationHandler = { proc in
				print(proc.terminationStatus)
				self.downloading = false
				print("Recording \(self.name) finished. Not auto retry...")
				self.process = nil
			}
		}
		print("Start recording \(name).")
		process?.launch()
	}
	
	deinit {
		process?.terminate()
		process = nil
	}
	
}

enum LiveWebsite: String {
	
	case douyu = "douyu"
	
	var fullUrl: String {
		switch self {
		case .douyu:
			return "http://www.douyu.com/"
		}
	}

	var fileSuffix: String {
		switch self {
		case .douyu:
			return "flv"
		}
	}
}
