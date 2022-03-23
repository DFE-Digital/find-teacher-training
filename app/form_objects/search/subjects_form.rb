module Search
  class SubjectsForm
    include ActiveModel::Model

    attr_accessor :subject_codes, :age_group

    validates :subject_codes, presence: true

    # These subjects don’t currently match any courses, and so can be dropped.
    IGNORED_SUBJECTS = ['Philosophy', 'Modern Languages', 'Ancient Hebrew', 'Ancient Greek'].freeze

    def primary_subjects
      primary_subjects = subject_areas.find { |sa| sa.id == 'PrimarySubject' }.subjects

      primary_subjects.map do |subject|
        Struct.new(:code, :name).new(subject.subject_code, subject.subject_name)
      end
    end

    def secondary_subjects
      secondary_subjects = subject_areas.find { |sa| sa.id == 'SecondarySubject' }.subjects
        .reject { |sa| IGNORED_SUBJECTS.include?(sa.subject_name) }
      modern_languages_subjects = subject_areas.find { |sa| sa.id == 'ModernLanguagesSubject' }.subjects

      (secondary_subjects + modern_languages_subjects).sort_by(&:subject_name)
    end

  private

    def subject_areas
      @subject_areas ||= SubjectArea.includes(:subjects).all
    end
  end
end
