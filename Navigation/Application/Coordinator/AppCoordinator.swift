//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 19.06.2022.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private var isAutorized = false
    private var isCheckedUser = true
    private var isNotFirstLogin: Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsEnum.isNotFirstLogin.rawValue)
    }
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure(isAutorized: isAutorized)
    }
    private var userService: UserService
    private let router: Router
    private var factory: ControllersFactoryProtocol
    private let localNotificationService = LocalNotificationsService()
    
    init(router: Router) {
        self.router = router
        #if DEBUG
        self.userService = TestUserService()
        #else
        self.userService = CurrentUserService()
        #endif
        self.factory = ControllerFactory(userService: userService)
    }
    
    override func start() {
        if isCheckedUser && isNotFirstLogin {
            CheckerService.shared.validateUser { [weak self] user in
                guard let self, let user else { self?.runAuthFlow(); return }
                self.userService.fetchUser(uid: user.uid) { result in
                    switch result {
                        case .success:
                            self.userService.fetchFiends {
                                self.runMainFlow()
                            }
                        case .failure(let failure):
                            print("failure runAuthFlow:\(failure)")
                            self.runAuthFlow()
                    }
                }
                
                runSplashScreen()
            }
        } else {
            if !isNotFirstLogin {
                UserDefaults.standard.set(true, forKey: UserDefaultsEnum.isNotFirstLogin.rawValue)
            }
            switch self.instructor {
                case .auth: self.runAuthFlow()
                case .main: self.runMainFlow()
            }
        }
    }
}

private extension AppCoordinator {
    func runAuthFlow() {
        let loginCoordinator = LoginCoordinator(router: router, factory: factory)
        loginCoordinator.finishFlow = { [weak self, weak loginCoordinator] user in
            if user != nil {
                self?.isAutorized = true
                self?.userService.set(user: user)
            }
            self?.start()
            self?.removeCoordinator(loginCoordinator)
        }
        addCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    func runMainFlow() {
        lazy var mainTabBarVC = TabBarController()
        let mainCoordinator = MainCoordinator(router: router, tabBarVC: mainTabBarVC, userService: userService, factory: factory)
        mainCoordinator.finishFlow = { [weak self, weak mainCoordinator] user in
            if user == nil {
                self?.isAutorized = false
                self?.isCheckedUser = true
                self?.userService.set(user: user)
                CheckerService.shared.logout { error in
                    if let error {
                        let inputData = UIAlertControllerInputData(message: error.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)])
                        self?.showAlert(inputData: inputData)
                    }
                }
            }
            self?.start()
            self?.removeCoordinator(mainCoordinator)
        }
        addCoordinator(mainCoordinator)
        router.setRootModule(mainTabBarVC, hideBar: true)
        mainCoordinator.start()
    }
    func runSplashScreen() {
        let svc = factory.makeSplashController()
        router.setRootModule(svc, hideBar: true)
    }
    func appConfiguration() {
        let appConfiguration = AppConfiguration.allCases.randomElement()
        NetworkManager.request(for: appConfiguration)
    }
    func localNotificationRegister() {
        localNotificationService.registeForLatestUpdatesIfPossible()
    }
    func showAlert(inputData: UIAlertControllerInputData) {
        let alert = UIAlertController(inputData: inputData)
        router.present(alert)
    }
}
