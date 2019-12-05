module PageObjects
  module Page
    class Course < SitePrism::Page
      def load_with_course(course)
        self.load(provider_code: course.provider_code, recruitment_cycle_year: course.recruitment_cycle_year, course_code: course.course_code)
      end

      element :title, ".govuk-heading-xl"
    end
  end
end
