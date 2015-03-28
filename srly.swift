#!/usr/bin/env xcrun swift

import Foundation

let home = NSHomeDirectory()

let ydlPath = "/usr/local/bin/youtube-dl"

let SafariReadingListId = "com.apple.ReadingList"
let plistPath = home + "/Library/Safari/Bookmarks.plist"

public class SRL {
    
    var plist: NSMutableDictionary = [:]
    var items: NSMutableArray = []

    init() {
        plist = readPlist()
        items = loadItems(plist)
    }
    
    public func save() {
        saveToDisk()
    }

    // MARK: Load info
    
    private func readPlist() -> NSMutableDictionary {
        let plist = NSMutableDictionary(contentsOfFile: plistPath)
        return plist!
    }
    
    private func loadItems(plist: NSDictionary) -> NSMutableArray {
        var children = plist.mutableArrayValueForKey("Children")
        var srl = children.objectAtIndex(indexOfReadingList(children)) as! NSMutableDictionary
        var items = srl.mutableArrayValueForKey("Children")
        return items
    }
    
    private func indexOfReadingList(array: NSArray) -> Int {
        for (index, item) in enumerate(array) {
            if let item = item as? Dictionary<String, AnyObject>,
                title = item["Title"] as? String
                where title == SafariReadingListId {
                    return index
            }
        }
        return 0
    }
    
    // MARK: Save
    
    private func saveToDisk() {
        plist.writeToFile(plistPath, atomically: true)
    }
}

extension SRL {
    typealias Item = Dictionary<String, AnyObject>
    
    class func title(item: AnyObject) -> String {
        return title(item as! Item)
    }
    
    class func title(item: Item) -> String {
        let urlDic = item["URIDictionary"] as! Dictionary<String, AnyObject>
        let title = urlDic["title"] as! String
        return title
    }
    
    class func url(item: AnyObject) -> String {
        return url(item as! Item)
    }
    
    class func url(item: Item) -> String {
        let urlString = item["URLString"] as! String
        return urlString
    }
}

//// ----

let srl = SRL()

var laters = srl.items

println("Number of READ IT LATER items: \(laters.count)")

for (index, item) in enumerate(Array(laters)) {
    println()
    let task = NSTask()
    task.launchPath = ydlPath
    // Don't try to be smart. youtube-dl can handle a lot of URLs.
    // It's better to try to download always ;)
    task.arguments = [SRL.url(item), "--no-playlist"]
    task.launch()
    task.waitUntilExit()
    println()

    if task.terminationStatus == 0 {
        laters.removeObjectAtIndex(index)
        srl.save()
    }
}

srl.save()
