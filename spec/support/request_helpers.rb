module Requests
  module Helpers

    def json
      @json ||= JSON.parse(response.body)
    end

    def json_headers
      { "Accept" => "application/json", "Content-Type" => "application/json"}
    end

     def expect_json_values_present(json, *keys)
      keys.each { |key| expect(json[key]).to_not be_nil, "key '#{key}' was expected to have some value, but it does not!" }
    end

    def expect_exact_json_keys(json, *keys)
      keys.each { |key| expect(json.include?(key)).to be_truthy, "key '#{key}' was expected to be present!" }
      expect((json.keys - keys).any?).to be_falsy, "Json has more keys than expected! '\"#{(json.keys - keys).join('", "')}\"'"
    end

    def expect_exact_json_values_present(json, *keys)
      expect_json_values_present(json, *keys)
      expect((json.keys - keys).any?).to be_falsy, "Json has more keys than expected! '\"#{(json.keys - keys).join('", "')}\"'"
    end

  end
end