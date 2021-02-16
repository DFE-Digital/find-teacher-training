module PageObjects
  module Page
    class ResultsWithNewFilters < SitePrism::Page
      set_url '/results'
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
        elements :show_vacancies, '[data-qa="course__has_vacancies"]'
      end

      class SubjectsSection < SitePrism::Section
        elements :subjects, '[data-qa="filters__subject_names"]'
        element :link, '[data-qa="link"]'
      end

      class StudyTypeSection < SitePrism::Section
        element :legend, 'legend'
        element :fulltime_checkbox, 'input[name="fulltime"]'
        element :parttime_checkbox, 'input[name="parttime"]'
      end

      class VacanciesSection < SitePrism::Section
        element :legend, 'legend'
        element :checkbox, 'input[name="hasvacancies"]'
      end

      class QualificationsSection < SitePrism::Section
        element :legend, 'legend'
        element :qts_checkbox, 'input[id="qualifications_qtsonly"]'
        element :pgce_checkbox, 'input[id="qualifications_pgdepgcewithqts"]'
        element :further_education_checkbox, 'input[id="qualifications_other"]'
      end

      class LocationAndProviderSection < SitePrism::Section
        element :name, '[data-qa="area_or_provider_name"]'
        element :link, '[data-qa="filters__area_and_provider_link"]'
      end

      class SendSection < SitePrism::Section
        element :legend, 'legend'
        element :checkbox, 'input[name="senCourses"]'
      end

      class ProviderSection < SitePrism::Section
        element :name, '[data-qa="provider_name"]'
        element :link, '[data-qa="link"]'
      end

      class FundingSection < SitePrism::Section
        element :legend, 'legend'
        element :checkbox, 'input[name="funding"]'
      end

      class SortFormSection < SitePrism::Section
        section :options, '[data-qa="sort-form__options"]' do
          element :ascending, '[data-qa="sort-form__options__ascending"]'
          element :descending, '[data-qa="sort-form__options__descending"]'
          element :distance, '[data-qa="sort-form__options__distance"]'
        end
        element :submit, '[data-qa="sort-form__submit"]'
      end

      class SuggestedSearchLinkSection < SitePrism::Section
        element :link, '[data-qa="link"]'
      end

      section :cookie_banner, CookieBannerSection, '[data-qa="cookie-banner"]'
      sections :courses, CourseSection, '[data-qa="course"]'
      section :subjects_filter, SubjectsSection, '[data-qa="filters__subjects"]'
      section :study_type_filter, StudyTypeSection, '[data-qa="filters__study_type"]'
      section :qualifications_filter, QualificationsSection, '[data-qa="filters__qualifications"]'
      section :vacancies_filter, VacanciesSection, '[data-qa="filters__vacancies"]'
      section :funding_filter, FundingSection, '[data-qa="filters__funding"]'
      section :provider_filter, ProviderSection, '[data-qa="filters__provider"]'

      section :area_and_provider_filter, LocationAndProviderSection, '[data-qa="filters__area_and_provider"]'
      section :send_filter, SendSection, '[data-qa="filters__send"]'

      element :heading, '[data-qa="heading"]'
      element :next_button, '[data-qa="next_button"]'
      element :previous_button, '[data-qa="previous_button"]'
      element :course_count, '[data-qa="course-count"]'
      element :location_link, '[data-qa="filters__location_link"]'
      element :subject_link, '[data-qa="filters__subject"]'
      element :qualification_link, '[data-qa="filters__qualification_link"]'
      element :salary_link, '[data-qa="filters__salary_link"]'
      element :vacancies_link, '[data-qa="filters__vacancies_link"]'

      element :suggested_searches, '[data-qa="suggested_searches"]'
      element :suggested_search_heading, '[data-qa="suggested_search_heading"]'
      element :suggested_search_description, '[data-qa="suggested_search_description"]'
      sections :suggested_search_links, SuggestedSearchLinkSection, '[data-qa="suggested_search_link"]'

      section :sort_form, SortFormSection, '[data-qa="sort-form"]'

      element :sorted_by_distance, '.app-search-results-header', text: 'Sorted by distance'
      element :feedback_link, '[data-qa=feedback-link]'

      element :apply_filters_button, '[data-qa=apply-filters]'
    end
  end
end
