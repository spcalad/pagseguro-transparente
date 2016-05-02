module PagSeguro
  class PreApprovalRequest
    class Serializer
      # The PreApprovalRequest that will be serialized.
      attr_reader :pre_approval_request#, :params

      def initialize(pre_approval_request)
        @pre_approval_request = pre_approval_request
        @params = {}
      end

      def to_params
        params[:redirect_url] = pre_approval_request.redirect_url
        params[:review_url] = pre_approval_request.review_url
        params[:reference] = pre_approval_request.reference

        serialize_sender(pre_approval_request.sender)
        serialize_pre_approval(pre_approval_request.pre_approval)

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderName] = sender.name
        params[:senderEmail] =  sender.email
        params[:senderHash] =  sender.hash_id

        serialize_document(sender.document)
        serialize_address(sender.address)
        serialize_phone(sender.phone)
      end

      def serialize_document(document)
         if document.cpf?
           params[:senderCPF] = document.value
         else
          params[:senderCNPJ] = document.value
        end
      end

      def serialize_address(address)
          return unless address

          params[:street] = address.street
          params[:number] = address.number
          params[:complement] = address.complement
          params[:district] = address.district
          params[:postalCode] = address.postal_code
          params[:city] = address.city
          params[:state] = address.state
          params[:country] = address.country
      end

      def serialize_phone(phone)
        return unless phone

        params[:senderAreaCode] = phone.area_code
        params[:senderPhone] = phone.number
      end

      def serialize_pre_approval(pre_approval)
        return unless pre_approval

        params[:preApprovalCharge] = pre_approval.charge
        params[:preApprovalName] = pre_approval.name
        params[:preApprovalDetails] = pre_approval.details
        params[:preApprovalAmountPerPayment] = to_amount(pre_approval.amount_per_payment)
        params[:preApprovalPeriod] = pre_approval.period
        params[:preApprovalFinalDate] = pre_approval.final_date
        params[:preApprovalMaxTotalAmount] = to_amount(pre_approval.max_total_amount)
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
