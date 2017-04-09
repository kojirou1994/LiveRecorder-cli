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

enum Signal: Int32 {
	case HUP    = 1
	case INT    = 2
	case QUIT   = 3
	case ABRT   = 6
	case KILL   = 9
	case ALRM   = 14
	case TERM   = 15
}

func trap(signal: Signal, action: @convention(c) (Int32) -> ()) {
	// From Swift, sigaction.init() collides with the Darwin.sigaction() function.
	// This local typealias allows us to disambiguate them.
	typealias SignalAction = sigaction
	
	var signalAction = SignalAction(__sigaction_u: unsafeBitCast(action, to: __sigaction_u.self), sa_mask: 0, sa_flags: 0)
	
	_ = withUnsafePointer(to: &signalAction) { actionPointer in
		sigaction(signal.rawValue, actionPointer, nil)
	}
}

let refresh: TimeInterval = 600

streamers = jsonDics.flatMap({ try? decode($0) })

let format: DateFormatter = {
	let f = DateFormatter()
	f.dateFormat = "yyyy-MM-dd HH:mm:ss"
	return f
}()

func start(force: Bool) {
	print("Active streamers: ")
	dump(streamers)
	streamers.forEach({ $0.record(force: force, autoRetry: true) })
	
	if #available(OSX 10.12, *) {
		_ = Timer.scheduledTimer(withTimeInterval: refresh, repeats: true, block: { (_) in
			print(format.string(from: Date()))
			print("Start checking...")
			streamers.forEach({ $0.record(force: force, autoRetry: true) })
			print("End checking.")
		})
	} else {
		// Fallback on earlier versions
		print("System Version too low.")
		exit(1)
	}
}

if CommandLine.argc > 1 {
	let filters = CommandLine.arguments[1..<Int(CommandLine.argc)]
	streamers = streamers.filter({ filters.contains($0.name) })
	start(force: true)
} else {
	start(force: false)
}

trap(signal: .INT) { signal in
	print("Exiting...")
	streamers = []
	exit(0)
}

RunLoop.main.run()

