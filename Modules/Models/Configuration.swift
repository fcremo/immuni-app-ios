// Configuration.swift
// Copyright (C) 2020 Presidenza del Consiglio dei Ministri.
// Please refer to the AUTHORS file for more information.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import ExposureNotification
import Foundation

public struct Configuration: Codable {
  enum CodingKeys: String, CodingKey {
    case minimumBuildVersion = "minimum_build_version"
    case serviceNotActiveNotificationPeriod = "service_not_active_notification_period"
    case osForceUpdateNotificationPeriod = "onboarding_not_completed_notification_period"
    case requiredUpdateNotificationPeriod = "required_update_notification_period"
    case riskReminderNotificationPeriod = "risk_reminder_notification_period"
    case exposureDetectionPeriod = "exposure_detection_period"
    case exposureConfiguration = "exposure_configuration"
    case exposureInfoMinimumRiskScore = "exposure_info_minimum_risk_score"
    case maximumExposureDetectionWaitingTime = "maximum_exposure_detection_waiting_time"
    case privacyPolicyURL = "pp_url"
    case tosURL = "tos_url"
    case faqURL = "faq_url"
    case operationalInfoWithExposureSamplingRate = "operational_info_with_exposure_sampling_rate"
    case operationalInfoWithoutExposureSamplingRate = "operational_info_without_exposure_sampling_rate"
    case dummyAnalyticsMeanStochasticDelay = "dummy_analytics_waiting_time"
  }

  /// This is used to enforce a minimum version of the app.
  /// If the currently installed app has a lower version than the one specified
  /// in the settings, the app schedules the reminder notification and
  /// displays the Update (App) screen.
  public let minimumBuildVersion: Int

  /// How often the notification of not active service is sent.
  /// It is expressed in seconds.
  public let serviceNotActiveNotificationPeriod: TimeInterval

  /// How often the notification of Update (OS) is sent.
  /// It is expressed in seconds.
  public let osForceUpdateNotificationPeriod: TimeInterval

  /// How often the notification of a new app update is sent. It is expressed in seconds.
  public let requiredUpdateNotificationPeriod: TimeInterval

  /// How often the notification of the risk state is sent,
  /// if the user hasn’t opened the app after the initial contact notification.
  /// It is expressed in seconds.
  public var riskReminderNotificationPeriod: TimeInterval

  /// How much time should pass between two consecutive exposure
  /// detections It is expressed in seconds.
  public var exposureDetectionPeriod: TimeInterval

  /// Parameters for exposure notifications.
  public let exposureConfiguration: ExposureDetectionConfiguration

  /// The minimum risk score that triggers the app to
  /// fetch the exposure info and notify the user using the SDK-provided
  /// notification.
  public let exposureInfoMinimumRiskScore: Int

  /// Maximum time from the last exposure detection that should
  /// pass before a foreground session should force a new one.
  public let maximumExposureDetectionWaitingTime: TimeInterval

  /// The url of the privacy policy
  public let privacyPolicyURL: URL

  /// The url of the terms of service
  public let tosURL: URL

  /// The urls of the FAQs for the various languages
  /// - note: this dictionary uses string as a key because only strings and ints
  /// are really considered as dictionaries by Codable
  /// https://bugs.swift.org/browse/SR-7788
  public let faqURL: [String: URL]

  /// Probability with which the app sends analytics data in case of match. Value in the [0, 1] range.
  public let operationalInfoWithExposureSamplingRate: Double

  /// Probability with which the app sends analytics data in case of non match. Value in the [0, 1] range.
  public let operationalInfoWithoutExposureSamplingRate: Double

  /// Mean of the exponential distribution that regulates the execution of dummy analytics requests
  public let dummyAnalyticsMeanStochasticDelay: Double

  /// The FAQ url for the given language. it returns english version if the given
  /// language is not available.
  /// Note that the method may still fail in case of missing english version
  public func faqURL(for language: UserLanguage) -> URL? {
    return self.faqURL[language.rawValue] ?? self.faqURL[UserLanguage.english.rawValue]
  }

  /// Public initializer to allow testing
  #warning("Tune default parameters")
  // swiftlint:disable force_unwrapping
  public init(
    minimumBuildVersion: Int = 0,
    serviceNotActiveNotificationPeriod: TimeInterval = 86400,
    osForceUpdateNotificationPeriod: TimeInterval = 86400,
    requiredUpdateNotificationPeriod: TimeInterval = 86400,
    riskReminderNotificationPeriod: TimeInterval = 86400,
    exposureDetectionPeriod: TimeInterval = 7200,
    exposureConfiguration: ExposureDetectionConfiguration = .init(),
    exposureInfoMinimumRiskScore: Int = 1,
    maximumExposureDetectionWaitingTime: TimeInterval = 86400,
    privacyPolicyURL: URL = URL(string: "http://www.example.com")!,
    tosURL: URL = URL(string: "http://www.example.com")!,
    faqURL: [String: URL] = [
      UserLanguage.english.rawValue: URL(string: "http://www.example.com")!,
      UserLanguage.italian.rawValue: URL(string: "http://www.example.com")!,
      UserLanguage.german.rawValue: URL(string: "http://www.example.com")!
    ],
    operationalInfoWithExposureSamplingRate: Double = 1,
    operationalInfoWithoutExposureSamplingRate: Double = 1,
    dummyAnalyticsWaitingTime: Double = 2_592_000
  ) {
    self.minimumBuildVersion = minimumBuildVersion
    self.serviceNotActiveNotificationPeriod = serviceNotActiveNotificationPeriod
    self.osForceUpdateNotificationPeriod = osForceUpdateNotificationPeriod
    self.requiredUpdateNotificationPeriod = requiredUpdateNotificationPeriod
    self.riskReminderNotificationPeriod = riskReminderNotificationPeriod
    self.exposureDetectionPeriod = exposureDetectionPeriod
    self.exposureConfiguration = exposureConfiguration
    self.exposureInfoMinimumRiskScore = exposureInfoMinimumRiskScore
    self.maximumExposureDetectionWaitingTime = maximumExposureDetectionWaitingTime
    self.privacyPolicyURL = privacyPolicyURL
    self.tosURL = tosURL
    self.faqURL = faqURL
    self.operationalInfoWithExposureSamplingRate = operationalInfoWithExposureSamplingRate
    self.operationalInfoWithoutExposureSamplingRate = operationalInfoWithoutExposureSamplingRate
    self.dummyAnalyticsMeanStochasticDelay = dummyAnalyticsWaitingTime
  }

  // swiftlint:enable force_unwrapping
}

public extension Configuration {
  struct ExposureDetectionConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
      case attenuationBucketScores = "attenuation_bucket_scores"
      case attenuationWeight = "attenuation_weight"
      case daysSinceLastExposureBucketScores = "days_since_last_exposure_bucket_scores"
      case daysSinceLastExposureWeight = "days_since_last_exposure_weight"
      case durationBucketScores = "duration_bucket_scores"
      case durationWeight = "duration_weight"
      case transmissionRiskBucketScores = "transmission_risk_bucket_scores"
      case transmissionRiskWeight = "transmission_risk_weight"
      case minimumRiskScore = "minimum_risk_score"
    }

    /// Scores that indicate Bluetooth signal strength.
    public let attenuationBucketScores: [UInt8]

    /// The weight applied to a Bluetooth signal strength score.
    public let attenuationWeight: Double

    /// Scores that indicate the days since the user’s last exposure.
    public let daysSinceLastExposureBucketScores: [UInt8]

    /// The weight assigned to a score applied to the days since the user’s exposure.
    public let daysSinceLastExposureWeight: Double

    /// Scores that indicate the duration of a user’s exposure.
    public let durationBucketScores: [UInt8]

    /// The weight assigned to a score applied to the duration of the user’s exposure.
    public let durationWeight: Double

    /// Scores for the user’s estimated risk of transmission.
    public let transmissionRiskBucketScores: [UInt8]

    /// The weight assigned to a score applied to the user’s risk of transmission.
    public let transmissionRiskWeight: Double

    /// The user’s minimum risk score.
    public let minimumRiskScore: UInt8

    /// Public initializer to allow testing
    #warning("Tune default parameters")
    public init(
      attenuationBucketScores: [UInt8] = [1, 1, 2, 3, 4, 5, 6, 7],
      attenuationWeight: Double = 1,
      daysSinceLastExposureBucketScores: [UInt8] = [1, 1, 2, 3, 4, 5, 6, 7],
      daysSinceLastExposureWeight: Double = 1,
      durationBucketScores: [UInt8] = [1, 1, 2, 3, 4, 5, 6, 7],
      durationWeight: Double = 1,
      transmissionRiskBucketScores: [UInt8] = [1, 1, 2, 3, 4, 5, 6, 7],
      transmissionRiskWeight: Double = 1,
      minimumRiskScore: UInt8 = 1
    ) {
      self.attenuationBucketScores = attenuationBucketScores
      self.attenuationWeight = attenuationWeight
      self.daysSinceLastExposureBucketScores = daysSinceLastExposureBucketScores
      self.daysSinceLastExposureWeight = daysSinceLastExposureWeight
      self.durationBucketScores = durationBucketScores
      self.durationWeight = durationWeight
      self.transmissionRiskBucketScores = transmissionRiskBucketScores
      self.transmissionRiskWeight = transmissionRiskWeight
      self.minimumRiskScore = minimumRiskScore
    }
  }
}
