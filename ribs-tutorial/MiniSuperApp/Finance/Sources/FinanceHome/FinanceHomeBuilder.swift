import ModernRIBs
import AddPaymentMethod
import FinanceRepository
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  public override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
    let balancePublisher = CurrentValuePublisher<Double>(0)
      
      let viewController = FinanceHomeViewController()
      let component = FinanceHomeComponent(dependency: dependency)
    
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
      
      let superPayDashBoardBuilder = SuperPayDashboardBuilder(dependency: component)
      let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
      let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
      
    return FinanceHomeRouter(interactor: interactor,
                             viewController: viewController,
                             superPayDashboardBuildable: superPayDashBoardBuilder,
                             cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
                             addPaymentMethodBuildable: addPaymentMethodBuilder,
                             topUpBuildable: component.topupBuildable)
  }
}
