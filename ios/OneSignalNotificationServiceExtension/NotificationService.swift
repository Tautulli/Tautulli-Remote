import CryptoSwift
import CommonCrypto
import Foundation
import OneSignal
import os.log
import SQLite3
import UIKit
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request;
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Parse notification payload
            let userInfo = request.content.userInfo
            if let custom = userInfo["custom"] as? [String: AnyObject] {
                let data = custom["a"]! as! [String: AnyObject]
                
                let version = data.keys.contains("version") ? data["version"] as! Int : 1
                let serverId = data["server_id"] as! String
                let serverInfoDict = getServerInfo(serverId: serverId)
                let deviceToken = serverInfoDict["deviceToken"]! as String
                
                let encrypted = data["encrypted"] as! Int
                var jsonMessage: [String: Any] = [:]
                
                if encrypted == 1 {
                    let salt = data["salt"] as! String
                    let nonce = data["nonce"] as! String
                    let cipherText = data["cipher_text"] as! String
                    jsonMessage = getUnencryptedMessage(version: version, deviceToken: deviceToken, salt: salt, nonce: nonce, cipherText: cipherText)
                } else {
                    jsonMessage = data["plain_text"] as! [String: Any]
                }

                print("Tautulli Notification Info: Notification content: \(jsonMessage)")
                
                bestAttemptContent.body = jsonMessage["body"] as! String
                bestAttemptContent.title = jsonMessage["subject"] as! String
                
                // Load image for notification
                // Used information from https://medium.com/@lucasgoesvalle/custom-push-notification-with-image-and-interactions-on-ios-swift-4-ffdbde1f457
                let notificationType = jsonMessage["notification_type"] as! Int
                if notificationType != 0 {
                    var connectionAddress: String?
                    if serverInfoDict["primaryActive"]! == "1" {
                        connectionAddress = serverInfoDict["primaryConnectionAddress"]!
                    } else {
                        connectionAddress = serverInfoDict["secondaryConnectionAddress"]!
                    }
                    
                    var urlString:String? = "\(connectionAddress!)/api/v2?apikey=\(deviceToken)&cmd=pms_image_proxy&app=true&img=\(jsonMessage["poster_thumb"]!)&width=1080"
                    
                    if let urlImageString = urlString as? String {
                        urlString = urlImageString
                    }

                    if urlString != nil, let fileUrl = URL(string: urlString!) {
                        print("fileUrl: \(fileUrl)")

                        guard let imageData = NSData(contentsOf: fileUrl) else {
                            return
                        }
                        guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "image.jpg", data: imageData, options: nil) else {
                            return
                        }

                        bestAttemptContent.attachments = [ attachment ]
                    }
                }

            }
            
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent, withContentHandler: self.contentHandler)
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
    private func getServerInfo(serverId: String) -> [String: String] {
        print("Tautulli Notification Info: Fetching server info for \(serverId)")

        let documentDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.tautulli.tautulliRemote.onesignal")
        let path = documentDir?.appendingPathComponent("tautulli_remote.db")
        var db: OpaquePointer?
        guard sqlite3_open(path?.path, &db) == SQLITE_OK else {
            os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "ERROR OPENING DB")
            sqlite3_close(db)
            db = nil
            return [String: String]()
        }
        let query = "SELECT primary_connection_address, secondary_connection_address, primary_active, device_token FROM servers WHERE tautulli_id = \"\(serverId)\""
        
        var primaryConnectionAddress = ""
        var secondaryConnectionAddress = ""
        var primaryActive = ""
        var deviceToken = ""
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "Error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            if let cString0 = sqlite3_column_text(statement, 0) {
                primaryConnectionAddress = String(cString: cString0)
            }
            if let cString1 = sqlite3_column_text(statement, 1) {
                secondaryConnectionAddress = String(cString: cString1)
            }
            if let cString2 = sqlite3_column_text(statement, 2) {
                primaryActive = String(cString: cString2)
            }
            if let cString3 = sqlite3_column_text(statement, 3) {
                deviceToken = String(cString: cString3)
            }
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "Error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "Error closing database")
        }
        
        db = nil
        
        let serverInfoDict: [String: String] = [
            "primaryConnectionAddress": primaryConnectionAddress,
            "secondaryConnectionAddress": secondaryConnectionAddress,
            "primaryActive": primaryActive,
            "deviceToken": deviceToken
        ]

        print("Tautulli Notification Info: Server info found: \(serverInfoDict)")
        
        return serverInfoDict
    }

    private func pbkdf2SHA1(password: String, saltData: Data, keyByteCount: Int, rounds: Int) -> Data? {
        return pbkdf2(password: password, saltData: saltData, keyByteCount: keyByteCount, prf: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA1), rounds: rounds)
    }

    private func pbkdf2SHA256(password: String, saltData: Data, keyByteCount: Int, rounds: Int) -> Data? {
        return pbkdf2(password: password, saltData: saltData, keyByteCount: keyByteCount,prf: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256),  rounds: rounds)
    }

    private func pbkdf2(password: String, saltData: Data, keyByteCount: Int, prf: CCPseudoRandomAlgorithm, rounds: Int) -> Data? {
    guard let passwordData = password.data(using: .utf8) else { return nil }
    var derivedKeyData = Data(repeating: 0, count: keyByteCount)
    let derivedCount = derivedKeyData.count
    let derivationStatus: Int32 = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
        let keyBuffer: UnsafeMutablePointer<UInt8> =
            derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
        return saltData.withUnsafeBytes { saltBytes -> Int32 in
            let saltBuffer: UnsafePointer<UInt8> = saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return CCKeyDerivationPBKDF(
                CCPBKDFAlgorithm(kCCPBKDF2),
                password,
                passwordData.count,
                saltBuffer,
                saltData.count,
                prf,
                UInt32(rounds),
                keyBuffer,
                derivedCount)
        }
    }
    return derivationStatus == kCCSuccess ? derivedKeyData : nil
}
    
    private func getUnencryptedMessage(version: Int, deviceToken: String, salt: String, nonce: String, cipherText: String) -> [String: Any] {
        print("Tautulli Notification Info: Encypted notification received...")

        let saltData: Data = Data(base64Encoded: salt)!
        let nonce: Array<UInt8> = Array(Data(base64Encoded: nonce)!.bytes)
        let cipherText: Array<UInt8> = Array(Data(base64Encoded: cipherText)!.bytes)

        if (version == 2) {
            do {
                let key = pbkdf2SHA256(password: deviceToken, saltData: saltData, keyByteCount: 32, rounds: 600000)
                let gcm = GCM(iv: nonce, mode: .combined)
                let aes = try AES(key: Array(key!), blockMode: gcm, padding: .noPadding)
                let plainText = try aes.decrypt(cipherText)

                let decryptedData = try JSONSerialization.jsonObject(with: Data(plainText)) as! [String: Any]

                print("Tautulli Notification Info: Decrypting v2 notification...")
                
                return decryptedData
            } catch {
                os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "FAILED TO DECRYPT: \(error)")

                print("Tautulli Notification Info: Issues decrypting notification, required data missing")
                
                return ["ERROR": error]
            }
        } else {
            do {
                let key = pbkdf2SHA1(password: deviceToken, saltData: saltData, keyByteCount: 32, rounds: 1000)
                let gcm = GCM(iv: nonce, mode: .combined)
                let aes = try AES(key: Array(key!), blockMode: gcm, padding: .noPadding)
                let plainText = try aes.decrypt(cipherText)

                let decryptedData = try JSONSerialization.jsonObject(with: Data(plainText)) as! [String: Any]

                print("Tautulli Notification Info: Decrypting v1 notification...")
                
                return decryptedData
            } catch {
                os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "FAILED TO DECRYPT: \(error)")

                print("Tautulli Notification Info: Issues decrypting notification, required data missing")
                
                return ["ERROR": error]
            }
        }
    }
}

extension UNNotificationAttachment {
    
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}