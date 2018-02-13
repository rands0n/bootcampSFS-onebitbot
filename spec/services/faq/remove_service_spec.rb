require_relative '../../spec_helper'

describe FaqModule::RemoveService do
  let(:company) { create(:company) }

  describe '#call' do
    let(:faq) { create(:faq, company: company) }

    context 'with valid ID' do
      it 'remove the faq' do
        remove_service = FaqModule::RemoveService.new({ :id => faq.id })

        response = remove_service.call

        expect(response).to match 'Deletado com sucesso'
      end

      it 'remove faq from the database' do
        remove_service = FaqModule::RemoveService.new({ :id => faq.id })

        expect(Faq.all.count).to eq(1)

        response = remove_service.call

        expect(Faq.all.count).to eq(0)
      end
    end

    context 'with invalid ID' do
      it 'receive error message' do
        remove_service = FaqModule::RemoveService.new({ :id => rand(1..100) })

        response = remove_service.call

        expect(response).to match 'Questão inválida, verifique o Id'
      end
    end
  end
end
