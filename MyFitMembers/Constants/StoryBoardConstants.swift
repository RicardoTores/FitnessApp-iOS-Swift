// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: nil)
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum ClientStoryboard: String, StoryboardSceneType {
    static let storyboardName = "ClientStoryboard"

    case ClientAddMeasurementViewControllerScene = "ClientAddMeasurementViewController"
    static func instantiateClientAddMeasurementViewController() -> ClientAddMeasurementViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientAddMeasurementViewControllerScene.viewController() as? ClientAddMeasurementViewController
      else {
        fatalError("ViewController 'ClientAddMeasurementViewController' is not of the expected class ClientAddMeasurementViewController.")
      }
      return vc
    }

    case ClientAddSelfieViewControllerScene = "ClientAddSelfieViewController"
    static func instantiateClientAddSelfieViewController() -> ClientAddSelfieViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientAddSelfieViewControllerScene.viewController() as? ClientAddSelfieViewController
      else {
        fatalError("ViewController 'ClientAddSelfieViewController' is not of the expected class ClientAddSelfieViewController.")
      }
      return vc
    }

    case ClientChatViewControllerScene = "ClientChatViewController"
    static func instantiateClientChatViewController() -> ClientChatViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientChatViewControllerScene.viewController() as? ClientChatViewController
      else {
        fatalError("ViewController 'ClientChatViewController' is not of the expected class ClientChatViewController.")
      }
      return vc
    }

    case ClientDashBoardViewControllerScene = "ClientDashBoardViewController"
    static func instantiateClientDashBoardViewController() -> ClientDashBoardViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientDashBoardViewControllerScene.viewController() as? ClientDashBoardViewController
      else {
        fatalError("ViewController 'ClientDashBoardViewController' is not of the expected class ClientDashBoardViewController.")
      }
      return vc
    }

    case ClientFitnessAssessmentViewControllerScene = "ClientFitnessAssessmentViewController"
    static func instantiateClientFitnessAssessmentViewController() -> ClientFitnessAssessmentViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientFitnessAssessmentViewControllerScene.viewController() as? ClientFitnessAssessmentViewController
      else {
        fatalError("ViewController 'ClientFitnessAssessmentViewController' is not of the expected class ClientFitnessAssessmentViewController.")
      }
      return vc
    }

    case ClientFitnessAssessmentsViewControllerScene = "ClientFitnessAssessmentsViewController"
    static func instantiateClientFitnessAssessmentsViewController() -> ClientFitnessAssessmentsViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientFitnessAssessmentsViewControllerScene.viewController() as? ClientFitnessAssessmentsViewController
      else {
        fatalError("ViewController 'ClientFitnessAssessmentsViewController' is not of the expected class ClientFitnessAssessmentsViewController.")
      }
      return vc
    }

    case ClientFoodPicsViewControllerScene = "ClientFoodPicsViewController"
    static func instantiateClientFoodPicsViewController() -> ClientFoodPicsViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientFoodPicsViewControllerScene.viewController() as? ClientFoodPicsViewController
      else {
        fatalError("ViewController 'ClientFoodPicsViewController' is not of the expected class ClientFoodPicsViewController.")
      }
      return vc
    }

    case ClientLeftDrawerViewControllerScene = "ClientLeftDrawerViewController"
    static func instantiateClientLeftDrawerViewController() -> ClientLeftDrawerViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientLeftDrawerViewControllerScene.viewController() as? ClientLeftDrawerViewController
      else {
        fatalError("ViewController 'ClientLeftDrawerViewController' is not of the expected class ClientLeftDrawerViewController.")
      }
      return vc
    }

    case ClientLessonViewControllerScene = "ClientLessonViewController"
    static func instantiateClientLessonViewController() -> ClientLessonViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientLessonViewControllerScene.viewController() as? ClientLessonViewController
      else {
        fatalError("ViewController 'ClientLessonViewController' is not of the expected class ClientLessonViewController.")
      }
      return vc
    }

    case ClientLessonsCollectionViewControllerScene = "ClientLessonsCollectionViewController"
    static func instantiateClientLessonsCollectionViewController() -> ClientLessonsCollectionViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientLessonsCollectionViewControllerScene.viewController() as? ClientLessonsCollectionViewController
      else {
        fatalError("ViewController 'ClientLessonsCollectionViewController' is not of the expected class ClientLessonsCollectionViewController.")
      }
      return vc
    }

    case ClientMeasurementViewControllerScene = "ClientMeasurementViewController"
    static func instantiateClientMeasurementViewController() -> ClientMeasurementViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientMeasurementViewControllerScene.viewController() as? ClientMeasurementViewController
      else {
        fatalError("ViewController 'ClientMeasurementViewController' is not of the expected class ClientMeasurementViewController.")
      }
      return vc
    }

    case ClientPersonalInfoViewControllerScene = "ClientPersonalInfoViewController"
    static func instantiateClientPersonalInfoViewController() -> ClientPersonalInfoViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientPersonalInfoViewControllerScene.viewController() as? ClientPersonalInfoViewController
      else {
        fatalError("ViewController 'ClientPersonalInfoViewController' is not of the expected class ClientPersonalInfoViewController.")
      }
      return vc
    }

    case ClientSelfiesViewControllerScene = "ClientSelfiesViewController"
    static func instantiateClientSelfiesViewController() -> ClientSelfiesViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientSelfiesViewControllerScene.viewController() as? ClientSelfiesViewController
      else {
        fatalError("ViewController 'ClientSelfiesViewController' is not of the expected class ClientSelfiesViewController.")
      }
      return vc
    }

    case ClientSettingsViewControllerScene = "ClientSettingsViewController"
    static func instantiateClientSettingsViewController() -> ClientSettingsViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientSettingsViewControllerScene.viewController() as? ClientSettingsViewController
      else {
        fatalError("ViewController 'ClientSettingsViewController' is not of the expected class ClientSettingsViewController.")
      }
      return vc
    }

    case ClientWeignInViewControllerScene = "ClientWeignInViewController"
    static func instantiateClientWeignInViewController() -> ClientWeignInViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientWeignInViewControllerScene.viewController() as? ClientWeignInViewController
      else {
        fatalError("ViewController 'ClientWeignInViewController' is not of the expected class ClientWeignInViewController.")
      }
      return vc
    }

    case ClientsInfoViewControllerScene = "ClientsInfoViewController"
    static func instantiateClientsInfoViewController() -> ClientsInfoViewController {
      guard let vc = StoryboardScene.ClientStoryboard.ClientsInfoViewControllerScene.viewController() as? ClientsInfoViewController
      else {
        fatalError("ViewController 'ClientsInfoViewController' is not of the expected class ClientsInfoViewController.")
      }
      return vc
    }
  }
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case AddClientViewControllerScene = "AddClientViewController"
    static func instantiateAddClientViewController() -> AddClientViewController {
      guard let vc = StoryboardScene.Main.AddClientViewControllerScene.viewController() as? AddClientViewController
      else {
        fatalError("ViewController 'AddClientViewController' is not of the expected class AddClientViewController.")
      }
      return vc
    }

    case AddWeighViewControllerScene = "AddWeighViewController"
    static func instantiateAddWeighViewController() -> AddWeighViewController {
      guard let vc = StoryboardScene.Main.AddWeighViewControllerScene.viewController() as? AddWeighViewController
      else {
        fatalError("ViewController 'AddWeighViewController' is not of the expected class AddWeighViewController.")
      }
      return vc
    }

    case BroadCastViewControllerScene = "BroadCastViewController"
    static func instantiateBroadCastViewController() -> BroadCastViewController {
      guard let vc = StoryboardScene.Main.BroadCastViewControllerScene.viewController() as? BroadCastViewController
      else {
        fatalError("ViewController 'BroadCastViewController' is not of the expected class BroadCastViewController.")
      }
      return vc
    }

    case ChangePasswordViewControllerScene = "ChangePasswordViewController"
    static func instantiateChangePasswordViewController() -> ChangePasswordViewController {
      guard let vc = StoryboardScene.Main.ChangePasswordViewControllerScene.viewController() as? ChangePasswordViewController
      else {
        fatalError("ViewController 'ChangePasswordViewController' is not of the expected class ChangePasswordViewController.")
      }
      return vc
    }

    case ChatViewControllerScene = "ChatViewController"
    static func instantiateChatViewController() -> ChatViewController {
      guard let vc = StoryboardScene.Main.ChatViewControllerScene.viewController() as? ChatViewController
      else {
        fatalError("ViewController 'ChatViewController' is not of the expected class ChatViewController.")
      }
      return vc
    }

    case ClientCollectionViewControllerScene = "ClientCollectionViewController"
    static func instantiateClientCollectionViewController() -> ClientCollectionViewController {
      guard let vc = StoryboardScene.Main.ClientCollectionViewControllerScene.viewController() as? ClientCollectionViewController
      else {
        fatalError("ViewController 'ClientCollectionViewController' is not of the expected class ClientCollectionViewController.")
      }
      return vc
    }

    case ClientGoalsViewControllerScene = "ClientGoalsViewController"
    static func instantiateClientGoalsViewController() -> ClientGoalsViewController {
      guard let vc = StoryboardScene.Main.ClientGoalsViewControllerScene.viewController() as? ClientGoalsViewController
      else {
        fatalError("ViewController 'ClientGoalsViewController' is not of the expected class ClientGoalsViewController.")
      }
      return vc
    }

    case ClientInfoStepOneViewControllerScene = "ClientInfoStepOneViewController"
    static func instantiateClientInfoStepOneViewController() -> ClientInfoStepOneViewController {
      guard let vc = StoryboardScene.Main.ClientInfoStepOneViewControllerScene.viewController() as? ClientInfoStepOneViewController
      else {
        fatalError("ViewController 'ClientInfoStepOneViewController' is not of the expected class ClientInfoStepOneViewController.")
      }
      return vc
    }

    case ClientInfoStepTwoViewControllerScene = "ClientInfoStepTwoViewController"
    static func instantiateClientInfoStepTwoViewController() -> ClientInfoStepTwoViewController {
      guard let vc = StoryboardScene.Main.ClientInfoStepTwoViewControllerScene.viewController() as? ClientInfoStepTwoViewController
      else {
        fatalError("ViewController 'ClientInfoStepTwoViewController' is not of the expected class ClientInfoStepTwoViewController.")
      }
      return vc
    }

    case ClientInfoThreeViewControllerScene = "ClientInfoThreeViewController"
    static func instantiateClientInfoThreeViewController() -> ClientInfoThreeViewController {
      guard let vc = StoryboardScene.Main.ClientInfoThreeViewControllerScene.viewController() as? ClientInfoThreeViewController
      else {
        fatalError("ViewController 'ClientInfoThreeViewController' is not of the expected class ClientInfoThreeViewController.")
      }
      return vc
    }

    case ClientInfoViewControllerScene = "ClientInfoViewController"
    static func instantiateClientInfoViewController() -> ClientInfoViewController {
      guard let vc = StoryboardScene.Main.ClientInfoViewControllerScene.viewController() as? ClientInfoViewController
      else {
        fatalError("ViewController 'ClientInfoViewController' is not of the expected class ClientInfoViewController.")
      }
      return vc
    }

    case ClientPagerViewControllerScene = "ClientPagerViewController"
    static func instantiateClientPagerViewController() -> ClientPagerViewController {
      guard let vc = StoryboardScene.Main.ClientPagerViewControllerScene.viewController() as? ClientPagerViewController
      else {
        fatalError("ViewController 'ClientPagerViewController' is not of the expected class ClientPagerViewController.")
      }
      return vc
    }

    case ClientViewControllerScene = "ClientViewController"
    static func instantiateClientViewController() -> ClientViewController {
      guard let vc = StoryboardScene.Main.ClientViewControllerScene.viewController() as? ClientViewController
      else {
        fatalError("ViewController 'ClientViewController' is not of the expected class ClientViewController.")
      }
      return vc
    }

    case DashBoardViewControllerScene = "DashBoardViewController"
    static func instantiateDashBoardViewController() -> DashBoardViewController {
      guard let vc = StoryboardScene.Main.DashBoardViewControllerScene.viewController() as? DashBoardViewController
      else {
        fatalError("ViewController 'DashBoardViewController' is not of the expected class DashBoardViewController.")
      }
      return vc
    }

    case EnlargedPicViewControllerScene = "EnlargedPicViewController"
    static func instantiateEnlargedPicViewController() -> EnlargedPicViewController {
      guard let vc = StoryboardScene.Main.EnlargedPicViewControllerScene.viewController() as? EnlargedPicViewController
      else {
        fatalError("ViewController 'EnlargedPicViewController' is not of the expected class EnlargedPicViewController.")
      }
      return vc
    }

    case FitnessAssessmentViewControllerScene = "FitnessAssessmentViewController"
    static func instantiateFitnessAssessmentViewController() -> FitnessAssessmentViewController {
      guard let vc = StoryboardScene.Main.FitnessAssessmentViewControllerScene.viewController() as? FitnessAssessmentViewController
      else {
        fatalError("ViewController 'FitnessAssessmentViewController' is not of the expected class FitnessAssessmentViewController.")
      }
      return vc
    }

    case FitnessAssessmentsViewControllerScene = "FitnessAssessmentsViewController"
    static func instantiateFitnessAssessmentsViewController() -> FitnessAssessmentsViewController {
      guard let vc = StoryboardScene.Main.FitnessAssessmentsViewControllerScene.viewController() as? FitnessAssessmentsViewController
      else {
        fatalError("ViewController 'FitnessAssessmentsViewController' is not of the expected class FitnessAssessmentsViewController.")
      }
      return vc
    }

    case FoodPicsViewControllerScene = "FoodPicsViewController"
    static func instantiateFoodPicsViewController() -> FoodPicsViewController {
      guard let vc = StoryboardScene.Main.FoodPicsViewControllerScene.viewController() as? FoodPicsViewController
      else {
        fatalError("ViewController 'FoodPicsViewController' is not of the expected class FoodPicsViewController.")
      }
      return vc
    }

    case LeftDrawerViewControllerScene = "LeftDrawerViewController"
    static func instantiateLeftDrawerViewController() -> LeftDrawerViewController {
      guard let vc = StoryboardScene.Main.LeftDrawerViewControllerScene.viewController() as? LeftDrawerViewController
      else {
        fatalError("ViewController 'LeftDrawerViewController' is not of the expected class LeftDrawerViewController.")
      }
      return vc
    }

    case LessonCollectionViewControllerScene = "LessonCollectionViewController"
    static func instantiateLessonCollectionViewController() -> LessonCollectionViewController {
      guard let vc = StoryboardScene.Main.LessonCollectionViewControllerScene.viewController() as? LessonCollectionViewController
      else {
        fatalError("ViewController 'LessonCollectionViewController' is not of the expected class LessonCollectionViewController.")
      }
      return vc
    }

    case LessonVideoViewControllerScene = "LessonVideoViewController"
    static func instantiateLessonVideoViewController() -> LessonVideoViewController {
      guard let vc = StoryboardScene.Main.LessonVideoViewControllerScene.viewController() as? LessonVideoViewController
      else {
        fatalError("ViewController 'LessonVideoViewController' is not of the expected class LessonVideoViewController.")
      }
      return vc
    }

    case LessonsViewControllerScene = "LessonsViewController"
    static func instantiateLessonsViewController() -> LessonsViewController {
      guard let vc = StoryboardScene.Main.LessonsViewControllerScene.viewController() as? LessonsViewController
      else {
        fatalError("ViewController 'LessonsViewController' is not of the expected class LessonsViewController.")
      }
      return vc
    }

    case MeasurementViewControllerScene = "MeasurementViewController"
    static func instantiateMeasurementViewController() -> MeasurementViewController {
      guard let vc = StoryboardScene.Main.MeasurementViewControllerScene.viewController() as? MeasurementViewController
      else {
        fatalError("ViewController 'MeasurementViewController' is not of the expected class MeasurementViewController.")
      }
      return vc
    }

    case MessageViewControllerScene = "MessageViewController"
    static func instantiateMessageViewController() -> MessageViewController {
      guard let vc = StoryboardScene.Main.MessageViewControllerScene.viewController() as? MessageViewController
      else {
        fatalError("ViewController 'MessageViewController' is not of the expected class MessageViewController.")
      }
      return vc
    }

    case NewBroadcastViewControllerScene = "NewBroadcastViewController"
    static func instantiateNewBroadcastViewController() -> NewBroadcastViewController {
      guard let vc = StoryboardScene.Main.NewBroadcastViewControllerScene.viewController() as? NewBroadcastViewController
      else {
        fatalError("ViewController 'NewBroadcastViewController' is not of the expected class NewBroadcastViewController.")
      }
      return vc
    }

    case NutritionAndResurcesViewControllerScene = "NutritionAndResurcesViewController"
    static func instantiateNutritionAndResurcesViewController() -> NutritionAndResurcesViewController {
      guard let vc = StoryboardScene.Main.NutritionAndResurcesViewControllerScene.viewController() as? NutritionAndResurcesViewController
      else {
        fatalError("ViewController 'NutritionAndResurcesViewController' is not of the expected class NutritionAndResurcesViewController.")
      }
      return vc
    }

    case SelfieViewControllerScene = "SelfieViewController"
    static func instantiateSelfieViewController() -> SelfieViewController {
      guard let vc = StoryboardScene.Main.SelfieViewControllerScene.viewController() as? SelfieViewController
      else {
        fatalError("ViewController 'SelfieViewController' is not of the expected class SelfieViewController.")
      }
      return vc
    }

    case SignInViewControllerScene = "SignInViewController"
    static func instantiateSignInViewController() -> SignInViewController {
      guard let vc = StoryboardScene.Main.SignInViewControllerScene.viewController() as? SignInViewController
      else {
        fatalError("ViewController 'SignInViewController' is not of the expected class SignInViewController.")
      }
      return vc
    }

    case TrainerProfileViewControllerScene = "TrainerProfileViewController"
    static func instantiateTrainerProfileViewController() -> TrainerProfileViewController {
      guard let vc = StoryboardScene.Main.TrainerProfileViewControllerScene.viewController() as? TrainerProfileViewController
      else {
        fatalError("ViewController 'TrainerProfileViewController' is not of the expected class TrainerProfileViewController.")
      }
      return vc
    }

    case TrainerSettingsViewControllerScene = "TrainerSettingsViewController"
    static func instantiateTrainerSettingsViewController() -> TrainerSettingsViewController {
      guard let vc = StoryboardScene.Main.TrainerSettingsViewControllerScene.viewController() as? TrainerSettingsViewController
      else {
        fatalError("ViewController 'TrainerSettingsViewController' is not of the expected class TrainerSettingsViewController.")
      }
      return vc
    }

    case WeighInViewControllerScene = "WeighInViewController"
    static func instantiateWeighInViewController() -> WeighInViewController {
      guard let vc = StoryboardScene.Main.WeighInViewControllerScene.viewController() as? WeighInViewController
      else {
        fatalError("ViewController 'WeighInViewController' is not of the expected class WeighInViewController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
  enum ClientStoryboard: String, StoryboardSegueType {
    case LogOutSegue = "LogOutSegue"
  }
  enum Main: String, StoryboardSegueType {
    case LogOutSegue = "LogOutSegue"
  }
}
