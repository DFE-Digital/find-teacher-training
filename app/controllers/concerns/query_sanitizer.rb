module QuerySanitizer
  def strip_non_ascii(query)
    query.encode("ASCII", invalid: :replace, undef: :replace, replace: "")
  end
end
