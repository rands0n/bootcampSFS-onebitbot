require '../../spec_helper'

describe FaqModule::ListService do
  let(:company) { create :company }

  describe '#call' do
    context 'with zero command' do
      context 'and zero faqs' do
        it 'return dont find message' do
          list_service = FaqModule::ListService.new({}, 'list')

          respose = list_service.call

          expect(response).to match 'Nada encontrado'
        end
      end
    end

    context 'with two faqs' do
      it 'find the question and answer in response' do
        list_service = FaqModule::ListService.new({}, 'list')

        faq1 = create(:faq, company: company)
        faq2 = create(:faq, company: company)

        response = list_service.call

        expect(response).to match faq1.question
        expect(response).to match faq1.answer

        expect(response).to match faq2.question
        expect(response).to match faq2.answer
      end
    end

    context 'with search command' do
      context 'with empty query' do
        it 'return dont find message' do
          list_service = FaqModule::ListService.new({ :query => '' }, 'search')

          response = list_service.call

          expect(response).to match 'Nada encontrado'
        end
      end

      context 'with valid query' do
        let(:faq) { create(:faq, company: company) }

        it 'find question and answer in response' do
          list_service = FaqModule::ListService.new({
            :query => faq.question.split('').sample
          }, 'search')

          response = list_service.call

          expect(response).to match faq.question
          expect(response).to match faq.answer
        end
      end
    end

    context 'with search_by_hashtag' do
      let(:faq) { create(:faq, company: company) }
      let(:hashtag) { create(:hashtag, company: @company) }
      let(:faq_hashtag) { create(:faq_hashtag, faq: faq, hashtag: hashtag) }

      context 'with valid hashtag' do
        it 'return don\'t find message' do
          list_service = FaqModule::ListService.new({ :query => '' }, 'search_by_hashtag')

          response = list_service.call

          expect(response).to match 'Nada encontrado'
        end
      end

      context 'with invalid hashtag' do
        it 'find question and answer in response' do
          list_service = FaqModule::ListService.new({ :query => hashtag.name }, 'search_by_hashtag')

          response = list_service.call

          expect(response).to match(faq.question)
          expect(response).to match(faq.answer)
        end
      end
    end
  end
end
