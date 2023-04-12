# frozen_string_literal: true

module ApiHelper
  def response_json
    JSON.parse(response.body)
  end
end