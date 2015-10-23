module PagSeguro
  class PreApprovalRequest < Request
    include ActiveModel::Validations

    validates_presence_of :redirect_url, :pre_approval, :sender
    validate :valid_pre_approval

    attr_accessor :redirect_url, :review_url, :sender, :pre_approval,
                  :reference

    # Calls the PagSeguro web service and register this request for pre_approval.
    def request_pre_approval(account = nil)
      params = Serializer.new(self).to_params
      PagSeguro::Transaction.new post('/pre-approvals/request-', API_V2 ,account, params).parsed_response
    end

    def initialize(options = {})
      @redirect_url = options[:redirect_url]
      @review_url = options[:review_url]
      @sender = options[:sender]
      @pre_approval = options[:pre_approval]
      @reference = options[:reference]
    end

    private
    def valid_pre_approval
      if pre_approval && !pre_approval.valid?
        errors.add(:pre_approval, " must be valid")
      end
    end
  end
end
