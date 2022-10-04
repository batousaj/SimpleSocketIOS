//
//  ViewController.swift
//  SampleAsyncSocket
//
//  Created by Thien Vu on 04/10/2022.
//

import UIKit
import CocoaAsyncSocket
import ProxyKit

let SERVER_HOST = "127.0.0.1"
let SERVER_PORT = 12345

let SERVER_PROXY_HOST = "127.0.0.1"
let SERVER_PROXY_PORT = 9050

class ViewController: UIViewController {
    
    let connectButton = UIButton()
    var proxySocks:SOCKSProxy!
    var proxySocket:GCDAsyncProxySocket!
    var socket:GCDAsyncSocket!
    
    var isProxy = true
    
    var dispatchQueue = DispatchQueue(label: "QueueProcessClient")
    var socketQueue = DispatchQueue(label: "QueueProcessSocket")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupButton()
        if isProxy {
            self.setupProxySocket()
        } else {
            self.setupSocket()
        }
    }

    func setupButton() {
        self.connectButton.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        self.view.addSubview(self.connectButton)
        self.connectButton.center = self.view.center
        self.connectButton.setTitle("Connected", for: .normal)
        self.connectButton.backgroundColor = .tintColor
        
        self.connectButton.addTarget(self, action: #selector(onClickConnectSocket), for: .touchUpInside)
        
    }
    
    func setupProxySocket() {
        self.proxySocks = SOCKSProxy()
        self.proxySocks.start(onPort: 9050)
        
        self.proxySocket = GCDAsyncProxySocket(delegate: self, delegateQueue: dispatchQueue, socketQueue: socketQueue)
        self.proxySocket.setProxyHost(SERVER_PROXY_HOST, port: UInt16(SERVER_PROXY_PORT), version: .version5)
    }
    
    func setupSocket() {
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatchQueue, socketQueue: socketQueue)
    }

}

extension ViewController {
    
    @objc func onClickConnectSocket() {
        
        if self.connectButton.titleLabel?.text == "Connected" {
            do {
                if self.isProxy {
                    try self.proxySocket.connect(toHost: SERVER_HOST, onPort: UInt16(SERVER_PORT), withTimeout: 1)
                } else {
                    try self.socket.connect(toHost: SERVER_HOST, onPort: UInt16(SERVER_PORT), withTimeout: 1)
                }
                DispatchQueue.main.async {
                    self.connectButton.setTitle("Disconnected", for: .normal)
                }
            } catch {
                print("error when connect socket")
            }
            
        } else {
            if self.isProxy {
                self.proxySocket.disconnect()
            } else {
                self.socket.disconnect()
            }

            DispatchQueue.main.async {
                self.connectButton.setTitle("Connected", for: .normal)
            }
        }
        
    }
    
}

extension ViewController : GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("Accepted socket")
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("Connected socket")
        
        let hello = "Hello I'm Thien"
        if self.isProxy {
            self.proxySocket.write(hello.data(using: .utf8), withTimeout: 5, tag: 0)
            self.proxySocket.readData(withTimeout: 1, tag: 0)
        } else {
            self.socket.write(hello.data(using: .utf8), withTimeout: 5, tag: 0)
            self.socket.readData(withTimeout: 1, tag: 0)
        }
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let str = String.init(data: data, encoding: .utf8) {
            print("did Read socket \(str)")
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("did Write Data socket")
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let err = err {
            print("Disconnected socket with error : \(err.localizedDescription)")
        } else {
            print("Disconnected socket")
        }
    }
    
}

