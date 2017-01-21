//
//  ViewController.swift
//  LiveRecorder
//
//  Created by 王宇 on 2017/1/17.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Cocoa
import Dispatch

class ViewController: NSViewController {
	
	var streamers: [LiveStreamer] = []
	
	var checkTimer: Timer!
	
	var refresh: TimeInterval = 600
	
	override func viewDidLoad() {
		super.viewDidLoad()
		readStreamers()
//		return;
		checkTimer = Timer.scheduledTimer(withTimeInterval: refresh, repeats: true, block: {[weak self] (_) in
			print("Timer start.")
			guard let `self` = self else {
				print("Timer not running.")
				return
			}
			self.streamers.forEach({ $0.record() })
			print("Timer finished.")
		})
		
		// Do any additional setup after loading the view.
	}
	
	override func viewDidAppear() {
		(NSApplication.shared().delegate as! AppDelegate).window = self.view.window
//		print(view.window)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	func readStreamers() {
		guard
		let data = try? Data(contentsOf: URL(fileURLWithPath: "/Users/Kojirou/Documents/RoomId.json")),
		let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
		let jsonDics = json as? [JSONDictionary]
		else {
			return
		}
		streamers = jsonDics.flatMap({ try? decode($0) })
	}
	
	func writeStreamers() {
		
	}

}

extension ViewController: NSTableViewDataSource {
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return streamers.count
	}
	
	
	/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
	*/
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		return "111"
	}
}

