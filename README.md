# srly.swift
Safari Reading List Youtube Downloader script written in Swift

# Installation
Just download this repository and save the script in some folder. 

*The script needs a Swift version currently in beta. You can change the default Swift version with:*

`xcode-select -s /Applications/Xcode-beta.app/Contents/Developer/`

# Usage
Run `./srly.swift` and the script will try to download any video from your Safari Reading List.

The script removes from the SRL the links that have been successfully downloaded.

# Requirements
- Swift 1.2 (Xcode 6.3)
- [youtube-dl](https://github.com/rg3/youtube-dl)