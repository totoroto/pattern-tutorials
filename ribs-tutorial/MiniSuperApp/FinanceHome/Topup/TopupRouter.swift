//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by summer on 1/2/24.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouting: Routing?
    
    private var navigationControllable: NavigationControllerable?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TopupInteractable,
         viewController: ViewControllable,
         addPaymentMethodBuildable: AddPaymentMethodBuildable,
         enterAmountBuildable: EnterAmountBuildable,
         cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() { 
        if viewController.uiviewController.presentationController != nil,
           navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil { return }
        let router = addPaymentMethodBuildable.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        
        attachChild(router)
        addPaymentMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    // MARK: - Private
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil { return }
        
        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }

    func attachEnterAmount() {
        if enterAmountRouting != nil { return }
        let router = enterAmountBuildable.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        
        attachChild(router)
        enterAmountRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }
    
    func attachCardOnFile() {
        if cardOnFileRouting != nil { return }
        let router = cardOnFileBuildable.build(withListener: interactor)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        
        attachChild(router)
        cardOnFileRouting = router
    }
    
    func detachCardOnFile() {
        guard let router = cardOnFileRouting else { return }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        cardOnFileRouting = nil
    }

    private let viewController: ViewControllable
}
