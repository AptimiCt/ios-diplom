//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 19.06.2022.
//

final class AppCoordinator: BaseCoordinator {
    
    private let router: Router
    
    private var isAutorized = false
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure(isAutorized: isAutorized)
    }
    private var user: User?
    
    private let localNotificationService = LocalNotificationsService()
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        switch instructor {
            case .auth: runAuthFlow()
            case .main: runMainFlow()
        }
    }
}

private extension AppCoordinator {
    func runAuthFlow() {
        let loginCoordinator = LoginCoordinator(router: router, factory: ControllerFactory())
        loginCoordinator.finishFlow = { [weak self, weak loginCoordinator] user in
            if user != nil {
                self?.isAutorized = true
                self?.user = user
            }
            self?.start()
            self?.removeCoordinator(loginCoordinator)
        }
        addCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    func runMainFlow() {
        guard let user else { return }
        lazy var mainTabBarVC = TabBarController()
        let mainCoordinator = MainCoordinator(router: router, tabBarVC: mainTabBarVC, with: user)
        mainCoordinator.finishFlow = { [weak self, weak mainCoordinator] user in
            if user == nil {
                self?.isAutorized = false
                self?.user = user
            }
            self?.start()
            self?.removeCoordinator(mainCoordinator)
        }
        addCoordinator(mainCoordinator)
        router.setRootModule(mainTabBarVC, hideBar: true)
        mainCoordinator.start()
    }
    func appConfiguration() {
        let appConfiguration = AppConfiguration.allCases.randomElement()
        NetworkManager.request(for: appConfiguration)
    }
    func localNotificationRegister() {
        localNotificationService.registeForLatestUpdatesIfPossible()
    }
}
