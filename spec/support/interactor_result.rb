module InteractorResult
  def ok(payload = {})
    OpenStruct.new({ success?: true }.merge(payload))
  end

  def fail_result(message: "error", payload: {})
    OpenStruct.new({ success?: false, message: message }.merge(payload))
  end
end
