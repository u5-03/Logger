// 
// Created on 2020/02/25
// Copyright © 2020年, yugo.sugiyama. All rights reserved.
//

import Foundation
import os.log

public enum LogCategory: String {
    case ui
    case transition
    case action
    case `deinit`
    case network
}

public enum LogType {
    case info
    case debug
    case error
    case fault
    case `default`
}

extension OSLogType {
    public var description: String {
        switch self {
        case .info: return "INFO"
        case .debug: return "DEBUG"
        case .error: return "ERROR"
        case .fault: return "FAULT"
        default: return "DEFAULT"
        }
    }
}

final public class Logger {
    public static func debugLog(message: String, logCategory: LogCategory, logType: LogType = .default) {
#if DEBUG
        let subsystem = Bundle.main.bundleIdentifier ?? "Logger"
        let osLog = OSLog(subsystem: subsystem, category: logCategory.rawValue)
        let osLogType: OSLogType
        switch logType {
        case .info: osLogType = .info
        case .debug: osLogType = .debug
        case .error: osLogType = .error
        case .fault: osLogType = .fault
        default: osLogType = .default
        }
        os_log("[%@] %@", log: osLog, type: osLogType, String(describing: logType), message)
#endif
    }

    /// This method is to check deinit is called. Write this method in 'deinit' block.
    /// - Parameter name: Write #file only
    public static func debugDeinit(filePath: String = #file, subMessage: String = "") {
#if DEBUG
        guard let fileURL = URL(string: filePath) else { return }
        let className = fileURL.deletingPathExtension().lastPathComponent
        let subsystem = Bundle.main.bundleIdentifier ?? "Logger"
        let osLog = OSLog(subsystem: subsystem, category: LogCategory.deinit.rawValue)
        let osLogType: OSLogType = .info
        os_log("[%@] %@", log: osLog, type: osLogType, osLogType.description, "\(className) Deinit \(subMessage)")
#endif
    }
}
