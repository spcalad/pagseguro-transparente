module PagSeguro
  class Sender
    include ActiveModel::Validations
    extend Forwardable

    def_delegators :phone, :area_code, :number
    def_delegators :address, :street, :number, :complement, :district, :postal_code, :city, :state, :country

    validates_presence_of :email, :name, :hash_id, :phone, :address

    # Set the sender e-mail.
    attr_accessor :email

    # Set the sender name.
    attr_accessor :name

    # Set the hash identifier.
    attr_accessor :hash_id

    # Set the CPF document.
    attr_accessor :document

    # Get the sender phone.
    attr_accessor :phone

    # Get the sender address.
    attr_accessor :address

    def initialize(options = {})
      @email = options[:email]
      @name = options[:name]
      @hash_id = options[:hash_id]
    end
  end
end
