@error_messages.to_hash.each do |field, messages|
  json.set! field do
    json.messages messages
  end
end