import ModernRIBs
import AddPaymentMethod
import FinanceRepository
import CombineUtil
import Topup

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var topupBaseViewController: ViewControllable
    
    init(dependency: FinanceHomeDependency,
         topupViewController: ViewControllable) {
        self.topupBaseViewController = topupViewController
        super.init(dependency: dependency)
    }
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let balancePublisher = CurrentValuePublisher<Double>(0)
      
      let viewController = FinanceHomeViewController()
      let component = FinanceHomeComponent(dependency: dependency,
                                           topupViewController: viewController)
    
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
      
      let superPayDashBoardBuilder = SuperPayDashboardBuilder(dependency: component)
      let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
      let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
      let topUpBuilder = TopupBuilder(dependency: component)
      
    return FinanceHomeRouter(interactor: interactor,
                             viewController: viewController,
                             superPayDashboardBuildable: superPayDashBoardBuilder,
                             cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
                             addPaymentMethodBuildable: addPaymentMethodBuilder,
                             topUpBuildable: topUpBuilder)
  }
}
