require "rails_helper"

describe CourseDecorator do
  let(:current_recruitment_cycle) { build :recruitment_cycle }
  let(:next_recruitment_cycle) { build :recruitment_cycle, :next_cycle }
  let(:provider) { build(:provider, accredited_body?: false, website: "www.acmescitt.com") }
  let(:english) { build(:subject, :english) }
  let(:biology) { build(:subject, :biology) }
  let(:mathematics) { build(:subject, :mathematics) }
  let(:subjects) { [english, mathematics] }

  let(:course) do
    build :course,
          course_code: "A1",
          name: "Mathematics",
          qualification: "pgce_with_qts",
          study_mode: "full_time",
          start_date: start_date,
          site_statuses: [site_status],
          provider: provider,
          accrediting_provider: provider,
          course_length: "OneYear",
          subjects: subjects,
          open_for_applications?: true,
          last_published_at: "2019-03-05T14:42:34Z",
          recruitment_cycle: current_recruitment_cycle
  end
  let(:start_date) { Time.zone.local(2019) }
  let(:site) { build(:site) }
  let(:site_status) do
    build(:site_status, :full_time_and_part_time, site: site)
  end

  let(:course_response) {
    course.to_jsonapi(
      include: %i[sites provider accrediting_provider recruitment_cycle subjects],
    )
  }

  let(:decorated_course) { course.decorate }

  it "returns the course name and code in brackets" do
    expect(decorated_course.name_and_code).to eq("Mathematics (A1)")
  end

  it "returns if course is an apprenticeship" do
    expect(decorated_course.apprenticeship?).to eq("No")
  end

  it "returns course length" do
    expect(decorated_course.length).to eq("1 year")
  end

  context "financial incentives" do
    describe "#salaried?" do
      let(:subject) { decorated_course }

      context "course is salaried" do
        let(:course) { build :course, funding_type: "salary" }

        it { is_expected.to be_salaried }
      end

      context "course is not salaried" do
        let(:course) { build :course, funding_type: "apprenticeship" }

        it { is_expected.to_not be_salaried }
      end
    end

    describe "#funding_option" do
      let(:subject) { decorated_course.funding_option }

      context "Salary" do
        let(:course) { build :course, funding_type: "salary" }

        it { is_expected.to eq("Salary") }
      end

      context "Bursary and Scholarship" do
        let(:mathematics) { build(:subject, :mathematics, scholarship: "2000", bursary_amount: "3000") }
        let(:course) { build :course, subjects: [mathematics] }

        it { is_expected.to eq("Scholarship, bursary or student finance if you’re eligible") }
      end

      context "Bursary" do
        let(:mathematics) { build(:subject, :mathematics, bursary_amount: "3000") }
        let(:course) { build :course, subjects: [mathematics] }

        it { is_expected.to eq("Bursary or student finance if you’re eligible") }
      end

      context "Student finance" do
        let(:course) { build :course }

        it { is_expected.to eq("Student finance if you’re eligible") }
      end

      context "Courses excluded from bursaries" do
        let(:pe) { build(:subject) }
        let(:english) { build(:subject, :english, bursary_amount: "3000") }

        let(:course) { build :course, name: "Drama with English", subjects: [pe, english] }

        it { is_expected.to eq("Student finance if you’re eligible") }
      end
    end

    describe "#subject_name" do
      context "course has more than one subject" do
        it "returns the course name" do
          expect(decorated_course.subject_name).to eq("Mathematics")
        end
      end

      context "course has one subject" do
        let(:subject) { build :subject, subject_name: "Computer Science" }
        let(:course) { build :course, subjects: [subject] }

        it "return the subject name" do
          expect(decorated_course.subject_name).to eq("Computer Science")
        end
      end
    end

    describe "#bursary_requirements" do
      let(:subject) { decorated_course.bursary_requirements }

      context "Course with mathematics as a subject" do
        let(:mathematics) { build :subject, :mathematics, subject_name: "Primary with Mathematics" }
        let(:english) { build :subject, :english }
        let(:subjects) { [mathematics, english] }

        expected_requirements = [
          "a degree of 2:2 or above in any subject",
          "at least grade B in maths A-level (or an equivalent)",
        ]

        it { is_expected.to eq(expected_requirements) }
      end

      context "Course without mathematics as a subject" do
        let(:english) { build :subject, :english }
        let(:subjects) { [biology, english] }

        expected_requirements = [
          "a degree of 2:2 or above in any subject",
        ]

        it { is_expected.to eq(expected_requirements) }
      end
    end

    describe "#bursary_first_line_ending" do
      let(:subject) { decorated_course.bursary_first_line_ending }

      context "More than one requirement" do
        let(:mathematics) { build :subject, :mathematics, subject_name: "Primary with Mathematics" }
        let(:english) { build :subject, :english }
        let(:subjects) { [mathematics, english] }

        expected_line_ending = ":"

        it { is_expected.to eq(expected_line_ending) }
      end

      context "Course without mathematics as a subject" do
        let(:english) { build :subject, :english }
        let(:subjects) { [biology, english] }

        expected_line_ending = "a degree of 2:2 or above in any subject."

        it { is_expected.to eq(expected_line_ending) }
      end
    end

    describe "#bursary_only" do
      let(:subject) { decorated_course }

      context "course only has bursary financial incentives" do
        let(:mathematics) { build :subject, bursary_amount: "2000" }
        let(:english) { build :subject, bursary_amount: "4000" }
        let(:subjects) { [mathematics, english] }

        it { is_expected.to be_bursary_only }
      end

      context "course has other financial incentives apart from bursaries" do
        let(:mathematics) { build :subject, bursary_amount: "2000" }
        let(:english) { build :subject, scholarship: "4000" }
        let(:subjects) { [mathematics, english] }

        it { is_expected.to_not be_bursary_only }
      end
    end

    describe "#has_bursary" do
      context "course has no bursary" do
        it "returns false" do
          expect(decorated_course.has_bursary?).to eq(false)
        end
      end

      context "course has bursary" do
        let(:mathematics) { build :subject, bursary_amount: "2000" }
        let(:english) { build :subject, bursary_amount: "4000" }
        let(:subjects) { [biology, mathematics, english] }

        it "returns true" do
          expect(decorated_course.has_bursary?).to eq(true)
        end
      end
    end

    describe "#bursary_amount" do
      context "course has bursary" do
        let(:mathematics) { build :subject, bursary_amount: "2000" }
        let(:english) { build :subject, bursary_amount: "4000" }
        let(:subjects) { [biology, mathematics, english] }

        it "returns the maximum bursary amount" do
          expect(decorated_course.bursary_amount).to eq("4000")
        end
      end
    end

    describe "#excluded_from_bursary?" do
      let(:subject) { decorated_course }

      context "course name does not qualify for exclusion" do
        let(:course) { build(:course, name: "Mathematics") }

        it { is_expected.to_not be_excluded_from_bursary }
      end

      context "course name contains 'with'" do
        context "Drama" do
          let(:english) { build :subject, bursary_amount: "30000" }
          let(:drama) { build :subject, subject_name: "Drama" }
          let(:subjects) { [english, drama] }

          context "Drama with English" do
            let(:course) { build(:course, name: "Drama with English", subjects: subjects) }

            it { is_expected.to be_excluded_from_bursary }
          end

          context "English with Drama" do
            let(:course) { build(:course, name: "English with Drama", subjects: subjects) }

            it { is_expected.to_not be_excluded_from_bursary }
          end
        end

        context "PE" do
          let(:english) { build :subject, bursary_amount: "30000" }
          let(:pe) { build :subject, subject_name: "PE" }
          let(:subjects) { [english, pe] }

          context "PE with English" do
            let(:course) { build(:course, name: "PE with English", subjects: subjects) }

            it { is_expected.to be_excluded_from_bursary }
          end

          context "English with PE" do
            let(:course) { build(:course, name: "English with PE", subjects: subjects) }

            it { is_expected.to_not be_excluded_from_bursary }
          end
        end

        context "Physical Education" do
          let(:english) { build :subject, bursary_amount: "30000" }
          let(:physical_education) { build :subject, subject_name: "Physical Education" }
          let(:subjects) { [english, physical_education] }

          context "Physical Education with English" do
            let(:course) { build(:course, name: "Physical Education with English", subjects: subjects) }

            it { is_expected.to be_excluded_from_bursary }
          end

          context "English with Physical Education" do
            let(:course) { build(:course, name: "English with Physical Education", subjects: subjects) }

            it { is_expected.to_not be_excluded_from_bursary }
          end
        end

        context "Media Studies" do
          let(:english) { build :subject, bursary_amount: "30000" }
          let(:media_studies) { build :subject, subject_name: "Media Studies" }
          let(:subjects) { [english, media_studies] }

          context "Media Studies with English" do
            let(:course) { build(:course, name: "Media Studies with English", subjects: subjects) }

            it { is_expected.to be_excluded_from_bursary }
          end

          context "English with Media Studies" do
            let(:course) { build(:course, name: "English with Media Studies", subjects: subjects) }

            it { is_expected.to_not be_excluded_from_bursary }
          end
        end
      end

      context "course name contains 'and'" do
        let(:english) { build :subject, bursary_amount: "30000" }
        let(:drama) { build :subject, subject_name: "Drama" }
        let(:subjects) { [english, drama] }

        context "Drama and English" do
          let(:course) { build(:course, name: "Drama and English", subjects: subjects) }

          it { is_expected.to_not be_excluded_from_bursary }
        end

        context "English and Drama" do
          let(:course) { build(:course, name: "English and Drama", subjects: subjects) }

          it { is_expected.to_not be_excluded_from_bursary }
        end
      end
    end

    describe "#scholarship_amount" do
      context "course has scholarship" do
        let(:mathematics) { build :subject, scholarship: "2000" }
        let(:english) { build :subject, scholarship: "4000" }
        let(:subjects) { [biology, mathematics, english] }

        it "returns the maximum scholarship amount" do
          expect(decorated_course.scholarship_amount).to eq("4000")
        end
      end
    end

    context "#has_scholarship?" do
      context "course has no scholarship" do
        it "returns false" do
          expect(decorated_course.has_scholarship?).to eq(false)
        end
      end

      context "course has scholarship" do
        let(:mathematics) { build :subject, scholarship: "6000" }
        let(:english) { build :subject, scholarship: "8000" }
        let(:subjects) { [biology, mathematics, english] }

        it "returns true" do
          expect(decorated_course.has_scholarship?).to eq(true)
        end
      end
    end

    context "early careers payment option" do
      context "course has no early career payment option" do
        it "returns false" do
          expect(decorated_course.has_early_career_payments?).to eq(false)
        end
      end

      context "course has early career payment option" do
        let(:english) { build :subject, early_career_payments: "2000" }
        let(:subjects) { [biology, mathematics, english] }

        it "returns true" do
          expect(decorated_course.has_early_career_payments?).to eq(true)
        end
      end
    end
  end
end
