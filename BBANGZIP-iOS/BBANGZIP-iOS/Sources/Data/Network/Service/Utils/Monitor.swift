//
//  Monitor.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Alamofire
import Foundation

final class Monitor: EventMonitor {
    let queue = DispatchQueue(label: "Monitor")
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        formatter.locale = .current
        
        return formatter
    }()
    
    func requestDidFinish(_ request: Request) {
        LoggerFactory.create(category: .data)
            .debug(
                """
                == 👉 NETWORK REQUEST FINISHED
                == * ID : \(request.id)
                == * TIME: \(self.dateFormatter.string(from: Date()))
                == * URL: \(String(describing: request.request?.url?.absoluteString ?? "NO URL"))
                == * METHOD: \(String(describing: (request.request?.httpMethod ?? "NO METHOD")))
                == * HEADER: \(String(describing: request.request?.allHTTPHeaderFields ?? [:]))
                == * BODY: \(String(describing: (request.request?.httpBody?.toPrettyPrintedString ?? "NO BODY")))
                """
            )
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        LoggerFactory.create(category: .data)
            .debug(
                """
                == 👈 NETWORK RESPONSE
                == * ID : \(request.id)
                == * TIME: \(self.dateFormatter.string(from: Date()))
                == * URL: \(String(describing: request.request?.url?.absoluteString ?? "NO URL"))
                == * STATUS_CODE: \(response.response?.statusCode ?? 0)
                == * DATA: \(String(response.data?.toPrettyPrintedString ?? "NO DATA"))
                """
            )
    }
}
