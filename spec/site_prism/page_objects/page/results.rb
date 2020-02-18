module PageObjects
  module Page
    class CookieBannerSection < SitePrism::Section
      element :cookies_info_link, '[data-qa="cookie-banner__info-link"]'
      element :accept_all_cookies, '[data-qa="cookie-banner__accept"]'
      element :set_preference_link, '[data-qa="cookie-banner__preference-link"]'
    end

    class CourseSection < SitePrism::Section
      element :provider_name, '[data-qa="course__provider_name"]'
      element :description, '[data-qa="course__description"]'
      element :name, '[data-qa="course__name"]'
      element :accrediting_provider, '[data-qa="course__accrediting_provider"]'
      element :funding_options, '[data-qa="course__funding_options"]'
      element :main_address, '[data-qa="course__main_address"]'
    end

    class SubjectsSection < SitePrism::Section
      element :send_courses, '[data-qa="send_courses"]'
      elements :subjects, '[data-qa="subjects"]'
      element :extra_subjects, '[data-qa="extra_subjects"]'
    end

    class StudyTypeSection < SitePrism::Section
      element :subheading, "h2"
      element :fulltime, '[data-qa="fulltime"]'
      element :parttime, '[data-qa="parttime"]'
      element :link, '[data-qa="link"]'
    end

    class VacanciesSection < SitePrism::Section
      element :subheading, "h2"
      element :vacancies, '[data-qa="vacancies"]'
      element :link, '[data-qa="link"]'
    end

    class QualificationsSection < SitePrism::Section
      elements :qualifications, '[data-qa="qualifications"]'
      element :link, '[data-qa="link"]'
      element :qts_only, '[data-qa="qts_only"]'
      element :pgde_pgce_with_qts, '[data-qa="pgde_pgce_with_qts"]'
      element :other_qualifications, '[data-qa="other_qualifications"]'
    end

    class FundingSection < SitePrism::Section
      element :funding, '[data-qa="funding"]'
      element :with_or_without_salary, '[data-qa="with-or-without-salary"]'
      element :with_salary, '[data-qa="with-salary"]'
      element :link, '[data-qa="link"]'
    end

    class LocationSection < SitePrism::Section
      element :name, '[data-qa="location_name"]'
      element :distance, '[data-qa="distance"]'
      element :map, '[data-qa="map"]'
      element :link, '[data-qa="change_link"]'
    end

    class ProviderSection < SitePrism::Section
      element :name, '[data-qa="provider_name"]'
      element :link, '[data-qa="change_link"]'
    end

    class Results < SitePrism::Page
      set_url "/results"

      section :cookie_banner, CookieBannerSection, '[data-qa="cookie-banner"]'
      sections :courses, CourseSection, '[data-qa="course"]'
      section :subjects_filter, SubjectsSection, '[data-qa="filters__subjects"]'
      section :study_type_filter, StudyTypeSection, '[data-qa="filters__studytype"]'
      section :qualifications_filter, QualificationsSection, '[data-qa="filters__qualifications"]'
      section :vacancies_filter, VacanciesSection, '[data-qa="filters__vacancies"]'
      section :funding_filter, FundingSection, '[data-qa="filters__funding"]'
      section :location_filter, LocationSection, '[data-qa="filters__location"]'
      section :provider_filter, ProviderSection, '[data-qa="filters__provider"]'

      element :provider_title, '[data-qa="provider_title"]'
      element :heading, '[data-qa="heading"]'
      element :next_button, '[data-qa="next_button"]'
      element :previous_button, '[data-qa="previous_button"]'

      element :location_link, '[data-qa="filters__location_link"]'
      element :subject_link, '[data-qa="filters__subject"]'
      element :qualification_link, '[data-qa="filters__qualification_link"]'
      element :salary_link, '[data-qa="filters__salary_link"]'
      element :vacancies_link, '[data-qa="filters__vacancies_link"]'
    end
  end
end
