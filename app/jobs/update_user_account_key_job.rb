class UpdateUserAccountKeyJob < ApplicationJob
  queue_as :default
  retry_on ExceptionCode, wait: 60.seconds, attempts: 3
  retry_on ActiveRecord::RecordInvalid, wait: 60.seconds, attempts: 3
  discard_on ActiveRecord::RecordNotFound
  discard_on ActiveJob::DeserializationError

  def perform(id)
    user = User.find(id)
    UserAccountKeyService.new(user).call
  end
end
