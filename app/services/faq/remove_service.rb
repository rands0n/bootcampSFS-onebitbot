module FaqModule
  class RemoveService
    def initialize(params)
      @company = Company.last
      @params = params
      @id = params["id"]
    end

    def call
      faq = @company.faqs.where(id: @id).last
      return 'Questão inválida, verifique o Id' if faq == nil

      Faq.transaction do
        faq.hashtags.each do |h|
          if h.faqs.count <= 1
            h.delete
          end
        end

        faq.delete
      end

      'Deletado com sucesso'
    end
  end
end