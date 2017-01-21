//
//  main.swift
//  LiveRecorder-cli
//
//  Created by 王宇 on 2017/1/18.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Foundation

var streamers: [LiveStreamer]

guard
	let data = try? Data(contentsOf: URL(fileURLWithPath: "/Users/Kojirou/Documents/RoomId.json")),
	let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
	let jsonDics = json as? [JSONDictionary]
	else {
		print("Cannot read room ids, exiting...")
		exit(0)
}

let refresh: TimeInterval = 600

streamers = jsonDics.flatMap({ try? decode($0) })

func start(force: Bool) {
	print("Active streamers: ")
	dump(streamers)
	streamers.forEach({ $0.record(force: force, autoRetry: true) })
	
	_ = Timer.scheduledTimer(withTimeInterval: refresh, repeats: true, block: { (_) in
		print("\(Date())Start checking...")
		streamers.forEach({ $0.record(force: force, autoRetry: true) })
		print("End checking.")
	})
}

if CommandLine.argc > 1 {
	let filters = CommandLine.arguments[1..<Int(CommandLine.argc)]
	streamers = streamers.filter({ filters.contains($0.name) })
	start(force: true)
} else {
	start(force: false)
}

RunLoop.main.run()

