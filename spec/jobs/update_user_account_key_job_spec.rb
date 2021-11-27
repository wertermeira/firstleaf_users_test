require 'rails_helper'

RSpec.describe UpdateUserAccountKeyJob, type: :job do
  let(:user) { create(:user) }

  describe '.perform_later' do
    it do
      expect do
        described_class.set(queue: 'default').perform_later(user.id)
      end.to have_enqueued_job.on_queue('default').at(:no_wait).with(user.id)
    end
  end

  describe '.perform_now' do
    let(:account_key_service) { instance_double(UserAccountKeyService) }
    before do
      allow(UserAccountKeyService).to receive(:new).with(user).and_return(account_key_service)
      allow(account_key_service).to receive(:call).and_return(:nil)
    end
    it do
      described_class.perform_now(user.id)
      expect(account_key_service).to have_received(:call)
    end
  end

  describe '.retry_on' do
    before do
      allow_any_instance_of(described_class).to receive(:perform).and_raise(exception)
    end
    context 'when ExceptionCode' do
      let(:exception) { ExceptionCode.new(500) }
      it do
        assert_performed_jobs 3 do
          described_class.perform_later(user.id)
        rescue StandardError
          nil
        end
      end
    end

    context 'when ActiveRecord::RecordInvalid' do
      let(:exception) { ActiveRecord::RecordInvalid }
      it do
        assert_performed_jobs 3 do
          described_class.perform_later(user.id)
        rescue StandardError
          nil
        end
      end
    end
  end

  describe '.discard_on' do
    before do
      allow_any_instance_of(described_class).to receive(:perform).and_raise(exception)
    end
    context 'when ActiveJob::DeserializationError' do
      let(:exception) { ActiveJob::DeserializationError }
      it do
        assert_performed_jobs 1 do
          described_class.perform_later(user.id)
        rescue StandardError
          nil
        end
      end
    end

    context 'when ActiveRecord::RecordNotFound' do
      let(:exception) { ActiveRecord::RecordNotFound }
      it do
        assert_performed_jobs 1 do
          described_class.perform_later(user.id)
        rescue StandardError
          nil
        end
      end
    end
  end
end
