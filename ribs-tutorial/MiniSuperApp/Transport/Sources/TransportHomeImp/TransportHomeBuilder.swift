import ModernRIBs
import FinanceRepository
import CombineUtil
import Topup
import TransportHome

public protocol TransportHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency, TopupDependency {
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    let topupBaseViewController: ViewControllable
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    init(dependency: TransportHomeDependency,
         topupBaseViewController: ViewControllable) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
  
  public override init(dependency: TransportHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
      let viewController = TransportHomeViewController()
      let component = TransportHomeComponent(dependency: dependency,
                                             topupBaseViewController: viewController)
      
    let interactor = TransportHomeInteractor(presenter: viewController,
                                             dependency: component)
    interactor.listener = listener
      
      let topupBuilder = TopupBuilder(dependency: component)
    
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
      topupBuildable: topupBuilder
    )
  }
}
