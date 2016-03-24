module PagSeguro
  class PreApproval
    include ActiveModel::Validations

    PERIOD_TYPES = %w(weekly monthly bimonthly trimonthly semiannually yearly)
    DAYS_OF_WEEK = %w(monday tuesday wednesday thursday friday saturday sunday)
    DATE_RANGE = 17856.hours

    attr_accessor :charge, :name, :details, :amount_per_payment, :period,
                  :final_date, :max_total_amount

    validates_presence_of :name, :period, :final_date, :max_total_amount, :charge
    validates_inclusion_of :period, in: PERIOD_TYPES
    validate :final_date_range

    def initialize(options = {})
      @charge = options[:charge]
      @name = options[:name]
      @details = options[:details]
      @amount_per_payment = options[:amount_per_payment]
      @period = options[:period]
      @final_date = options[:final_date]
      @max_total_amount = options[:max_total_amount]
    end

    def period
      @period.to_s.downcase
    end

    def final_date
      @final_date.to_datetime if @final_date.present?
    end

    def weekly?
      period == 'weekly'
    end

    def monthly?
      %w(monthly bimonthly trimonthly).include? period
    end

    def yearly?
      period == 'yearly'
    end

    protected
      def final_date_range
        return unless final_date
        errors.add(:final_date) if final_date < (Time.now) - 5.minutes
        errors.add(:final_date) if final_date > (Time.now) + DATE_RANGE
      end
  end
end
