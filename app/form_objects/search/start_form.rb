module Search
  class StartForm
    include ActiveModel::Model

    attr_accessor :l, :lq, :query

    validates :l, presence: true
    validates :lq, presence: true, if: :location_search?
    validates :query, presence: true, if: :provider_search?

    private

    def location_search?
      l == '1'
    end

    def provider_search?
      l == '3'
    end
  end
end
