import CryptoSwift
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
                
                let serverId = data["server_id"] as! String
                let serverInfoDict = getServerInfo(serverId: serverId)
                let deviceToken = serverInfoDict["deviceToken"]! as String
                
                let salt = data["salt"] as! String
                let nonce = data["nonce"] as! String
                let cipherText = data["cipher_text"] as! String
                
                let encrypted = data["encrypted"] as! Int
                let plainText = encrypted == 1 ? getUnencryptedMessage(deviceToken: deviceToken, salt: salt, nonce: nonce, cipherText: cipherText) : data["plain_text"] as! String
                
                do {
                    let jsonMessage = try JSONSerialization.jsonObject(with: Data(plainText.utf8)) as? [String: Any]
                    
                    let notificationType = jsonMessage!["notification_type"] as! Int
                    
                    bestAttemptContent.body = jsonMessage!["body"] as! String
                    bestAttemptContent.title = jsonMessage!["subject"] as! String
                    
                    if notificationType != 0 {
                        var connectionAddress: String?
                        if serverInfoDict["primaryActive"]! == "1" {
                            connectionAddress = serverInfoDict["primaryConnectionAddress"]!
                        } else {
                            connectionAddress = serverInfoDict["secondaryConnectionAddress"]!
                        }
                        
                        let urlString = "\(connectionAddress!)/api/v2?apikey=\(deviceToken)&cmd=pms_image_proxy&app=true&img=\(jsonMessage!["poster_thumb"]!)&width=1080"
                        // os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "URL STRING: \(urlString)")
                    }
                } catch {
                    os_log("%{public}@", log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, "JSON ERROR: \(error)")
                }
            }
            
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent)
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
        
        return serverInfoDict
    }
    
    private func getUnencryptedMessage(deviceToken: String, salt: String, nonce: String, cipherText: String) -> String {
        let password: Array<UInt8> = Array(deviceToken.utf8)
        let salt: Array<UInt8> = Array(Data(base64Encoded: salt)!.bytes)
        let nonce: Array<UInt8> = Array(Data(base64Encoded: nonce)!.bytes)
        let cipherText: Array<UInt8> = Array(Data(base64Encoded: cipherText)!.bytes)
        
        do {
            let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 1000, keyLength: 32, variant: .sha1).calculate()
            let gcm = GCM(iv: nonce, mode: .combined)
            let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
            let plainText = try aes.decrypt(cipherText)
            
            return String(bytes: plainText, encoding: .utf8)!
        } catch {
            return "FAILED TO DECRYPT: \(error)"
        }
    }
}
