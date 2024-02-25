//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by summer on 1/2/24.
//

import ModernRIBs
import FinanceRepository
import FinanceEntity
import CombineUtil
import AddPaymentMethod

public protocol TopupDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    
    init(dependency: TopupDependency,
         paymentMethodStream: CurrentValuePublisher<PaymentMethod>) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
        let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
        
        let component = TopupComponent(dependency: dependency,
                                       paymentMethodStream: paymentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(interactor: interactor,
                           viewController: component.topupBaseViewController,
                           addPaymentMethodBuildable: addPaymentMethodBuilder,
                           enterAmountBuildable: enterAmountBuilder,
                           cardOnFileBuildable: cardOnFileBuilder)
    }
}
