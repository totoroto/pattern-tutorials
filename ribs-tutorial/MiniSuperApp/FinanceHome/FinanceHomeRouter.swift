import ModernRIBs
import AddPaymentMethod
import SuperUI


protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
    private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    private var cardOnFileRouting: Routing?
    
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let topUpBuildable: TopupBuildable
    private var topUpRouting: Routing?
    
  // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superPayDashboardBuildable: SuperPayDashboardBuildable,
         cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
         addPaymentMethodBuildable: AddPaymentMethodBuildable,
         topUpBuildable: TopupBuildable) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.topUpBuildable = topUpBuildable
        
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
    
    func attachCardOnFileDashboard() {
        if cardOnFileRouting != nil { return }
        let router = cardOnFileDashboardBuildable.build(withListener: interactor)
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        self.cardOnFileRouting = router
        attachChild(router)
    }
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil { return }
        let router = addPaymentMethodBuildable.build(withListener: interactor,
                                                     closeButtonType: .close)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(navigation, animated: true, completion: nil)
        self.addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else { return }
        viewControllable.dismiss(completion: nil)

        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachTopUp() {
        if topUpRouting != nil { return }
        let router = topUpBuildable.build(withListener: interactor)
        self.topUpRouting = router
        attachChild(router)
    }
    
    func detachTopUp() {
        guard let router = topUpRouting else { return }
        detachChild(router)
        topUpRouting = nil
    }
}
