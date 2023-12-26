import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
  // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superPayDashboardBuildable: SuperPayDashboardBuildable) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
    
    func attachSuperPayDashboard() {
        if superPayRouting != nil { return } // 자식을 두번 붙이지 않도록 방어 로직 추가
        
        let router = superPayDashboardBuildable.build(withListener: interactor) // 자식 리블렛의 리스너는 비즈니스 로직을 담당하는 interactor
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        self.superPayRouting = router
        
        attachChild(router)
    }
}
