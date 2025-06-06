import WebKit
import SwiftUI

protocol TiogaViewModelDelegate: AnyObject {
    func tiogaViewModel(_ model: TiogaViewModel, didUpdateState state: TiogaState)
}

final class TiogaViewModel: ObservableObject {
    @Published private(set) var tiogaStatus: TiogaState = .idle
    let tiogaUrl: URL
    private var webView: WKWebView?
    weak var delegate: TiogaViewModelDelegate?
    private var progressObservation: NSKeyValueObservation?

    init(url: URL) {
        self.tiogaUrl = url
    }

    func bind(delegate: TiogaViewModelDelegate) {
        self.delegate = delegate
    }

    func attachWebView(_ webView: WKWebView) {
        self.webView = webView
        webView.navigationDelegate = TiogaWebDelegate(owner: self)
        observeProgress(webView)
        reloadContent()
    }

    private func observeProgress(_ webView: WKWebView) {
        progressObservation?.invalidate()
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, change in
            guard let self = self else { return }
            let progress = webView.estimatedProgress
            if progress < 1.0 {
                self.updateState(.loading(progress))
            } else {
                self.updateState(.completed)
            }
        }
    }

    func reloadContent() {
        guard let webView = webView else { return }
        updateState(.loading(0))
        let request = URLRequest(url: tiogaUrl, timeoutInterval: 15)
        webView.load(request)
    }

    func setConnection(isOnline: Bool) {
        if isOnline {
            if tiogaStatus == .offline {
                reloadContent()
            }
        } else {
            updateState(.offline)
        }
    }

    fileprivate func updateState(_ state: TiogaState) {
        tiogaStatus = state
        delegate?.tiogaViewModel(self, didUpdateState: state)
    }
}

private class TiogaWebDelegate: NSObject, WKNavigationDelegate {
    weak var owner: TiogaViewModel?

    init(owner: TiogaViewModel) {
        self.owner = owner
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        owner?.updateState(.loading(0.0))
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {}

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        owner?.updateState(.completed)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        owner?.updateState(.failed(error))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        owner?.updateState(.failed(error))
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {}

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {}
}
