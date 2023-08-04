//
//  Copyright 2020 Grabtaxi Holdings PTE LTE (GRAB), All rights reserved.
//  Use of this source code is governed by an MIT-style license that can be found in the LICENSE file
//

import Foundation
import SwiftLeakCheck

func xcodeWarning(path: String, leak: Leak) -> String {
    return "\(path):\(leak.line):\(leak.column): warning: `self` is strongly captured"
}

enum CommandLineError: Error, LocalizedError {
  case missingFileName
  
  var errorDescription: String? {
    switch self {
    case .missingFileName:
      return "Missing file or directory name"
    }
  }
}

do {
  let arguments = CommandLine.arguments
  guard arguments.count > 1 else {
    throw CommandLineError.missingFileName
  }
  
  let path = arguments[1]
  let url = URL(fileURLWithPath: path)
  let dirScanner = DirectoryScanner(callback: { fileUrl, shouldStop in
    do {
      guard fileUrl.pathExtension == "swift" else {
        return
      }

      let leakDetector = GraphLeakDetector()
      leakDetector.nonEscapeRules = [
        UIViewAnimationRule(),
        UIViewControllerAnimationRule(),
        DispatchQueueRule()
        ] + CollectionRules.rules
      
      let leaks = try leakDetector.detect(fileUrl)

      leaks.forEach { leak in
          print(xcodeWarning(path: fileUrl.path, leak: leak))
      }
    } catch {}
  })
  
  dirScanner.scan(url: url)
  
} catch {
  print("\(error.localizedDescription)")
}


