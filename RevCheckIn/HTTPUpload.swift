//
//  HTTPUpload.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/29/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import Foundation
import MobileCoreServices

public class HTTPUpload: NSObject {
    var fileUrl: NSURL? {
        didSet {
            updateMimeType()
        }
    }
    var mimeType: String?
    var data: NSData?
    var fileName: String?
    //gets the mimeType from the fileUrl, if possible
    func updateMimeType() {
        if mimeType == nil && fileUrl != nil {
            var UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileUrl?.pathExtension as NSString?, nil);
            var str = UTTypeCopyPreferredTagWithClass(UTI.takeUnretainedValue(), kUTTagClassMIMEType);
            if (str == nil) {
                mimeType = "application/octet-stream";
            } else {
                mimeType = str.takeUnretainedValue() as NSString
            }
        }
    }
    //default init does nothing
    override init() {
        super.init()
    }
    ///upload a file with a fileUrl. The fileName and mimeType will be infered
    convenience init(fileUrl: NSURL) {
        self.init()
        self.fileUrl = fileUrl
    }
    ///upload a file from a a data blob. Must add a filename and mimeType as that can't be infered from the data
    convenience init(data: NSData, fileName: String, mimeType: String) {
        self.init()
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}