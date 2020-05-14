class JSONAPIMockSerializable
  attr_reader :attributes,
              :id,
              :include_counts,
              :include_nulls,
              :missing_relationships,
              :present_relationships,
              :relationships,
              :type

  def initialize(id, type, attributes:, relationships: {}, include_counts: [], include_nulls: [])
    @attributes = attributes
    @id = id
    @relationships = relationships
    @include_counts = include_counts
    @include_nulls = include_nulls
    @missing_relationships = relationships.select { |_r, v| v.nil? }
    @present_relationships = relationships.reject { |_r, v| v.nil? }
    @type = type
  end

  def get_related
    (
      present_relationships.values +
      present_relationships.values.flatten.map(&:get_related)
    ).flatten.uniq
  end

  def render
    included_relationships = get_related.map(&:to_jsonapi_data)
    {
      data: to_jsonapi_data,
      included: included_relationships,
    }
  end

  def to_jsonapi_data
    relationships_jsonapi = relationships.map do |name, data|
      [
        name,
        if name.in?(include_nulls)
          {
            data: nil,
          }
        elsif data.nil?
          {
            meta: { included: false },
          }
        elsif name.in?(include_counts)
          {
            meta: {
              count: data.size,
            },
          }
        elsif data.is_a? Array
          {
            data: data.map(&:to_jsonapi_relationship),
          }
        else
          {
            data: data.to_jsonapi_relationship,
          }
        end,
      ]
    end
    relationships_jsonapi = relationships_jsonapi.to_h
    data = {
      id: id.to_s,
      type: type,
      attributes: attributes,
    }
    if relationships_jsonapi.any?
      data[:relationships] = relationships_jsonapi
    end
    data
  end

  def to_jsonapi_relationship
    {
      id: id.to_s,
      type: type,
    }
  end

  def to_resource
    type.classify.constantize.new(to_jsonapi_data)
  end

  def respond_to_missing?(method, include_all)
    if attributes.key? method
      true
    else
      super
    end
  end

  def method_missing(method)
    attributes.fetch(method) { super }
  end
end
