// HomeViewController.swift
// Auth0Sample
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Auth0

class HomeViewController: UIViewController {
    
    var coordinator: Coordinator? = nil

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coordinator = Coordinator()
    }

    // MARK: - IBAction

    @IBAction func showLoginController(_ sender: UIButton) {
        self.checkAccessToken()
    }

    // MARK: - Private

    private func showLogin() {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .audience("https://" + clientInfo.domain + "/userinfo")
            .scope("openid profile")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken else { return }
                    AuthSessionManager.shared.storeTokens(accessToken, idToken: idToken)
                    AuthSessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                return self.showLogin()
                            }
                            // should have Profile now
                            print(AuthSessionManager.shared.profile?.email)
                            Auth0
                                .users(token: idToken)
                                .get(AuthSessionManager.shared.profile!.sub, fields: ["user_metadata"], include: true)
                                .start { result in
                                    switch result {
                                    case .success(let user):
                                        print(user)
                                        self.showHome()
                                    case .failure(let error):
                                        print(error)
                                    }
                            }

                        }
                    }
                }
        }
    }
    
    private func showHome() {
        if let homeTabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC") {
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = homeTabBarVC
            }
        }
    }

    private func checkAccessToken() {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        AuthSessionManager.shared.retrieveProfile { error in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    guard error == nil else {
                        return self.showLogin()
                    }
                    //dump(AuthSessionManager.shared.profile)
                    self.showHome()
                }
            }
        }
    }
    
    
}
