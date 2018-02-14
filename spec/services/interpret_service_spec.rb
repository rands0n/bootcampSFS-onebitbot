require_relative './../spec_helper'

describe InterpretService do
  let(:company) { create(:company) }

  describe '#list' do
    context 'with zero faqs' do
      it 'return don\'t find message' do
        response = InterpretService.call('list', {})

        expect(response).to match 'Nada encontrado'
      end
    end

    context 'with two faqs' do
      let(:faq1) { create(:faq, company: @company) }
      let(:faq2) { create(:faq, company: @company) }

      it 'find the question and answer in the response' do
        response = InterpretService.call('list', {})

        expect(response).to match(faq1.question)
        expect(response).to match(faq1.answer)
        expect(response).to match(faq2.question)
        expect(response).to match(faq2.answer)
      end
    end
  end

  describe '#search' do
    context 'with empty query' do
      it 'return don\'t find message' do
        response = InterpretService.new('search', { :query => '' })

        expect(respone).to match 'Nada encontrado'
      end
    end

    context 'with valid query' do
      let(:faq) { create(:faq, company: company) }

      it 'find question and answer in response' do
        response = InterpretService.call('search', { :query => faq.question.split(" ").sample })

        expect(response).to match(faq.question)
        expect(response).to match(faq.answer)
      end
    end

    context 'by category' do
      context 'with invalid hashtag' do
        it 'return don\'t find message' do
          response = InterpretService.call('search_by_hashtag', { :query => '' })

          expect(response).to match("Nada encontrado")
        end
      end

      context 'with valid hashtag' do
        let(:faq) { create(:faq, company: @company) }
        let(:hashtag) { create(:hashtag, company: @company) }
        let(:faq_hashtag) { create(:faq_hashtag, faq: faq, hashtag: hashtag) }

        it 'find the question and answer in response' do
          response = InterpretService.call('search_by_hashtag', { :query => hashtag.name })

          expect(response).to match(faq.question)
          expect(response).to match(faq.answer)
        end
      end
    end
  end

  describe '#create' do
    let(:question) { FFaker::Lorem.sentence }
    let(:answer) { FFaker::Lorem.sentence }
    let(:hashtags) { "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}" }

    context 'without hashtag param' do
      it 'receiver an error' do
        response = InterpretService.new('create', {
          'question-original': question,
          'answer-original': answer
        })

        expect(response).to match 'Hashtag Obrigatória'
      end
    end

    context 'with valid params' do
      it 'receive success message' do
        response = InterpretService.new('create', {
          'question-original': question,
          'answer-original': answer,
          'hashtags-original': hashtags
        })

        expect(response).to match 'Criado com sucesso'
      end

      it 'find question and anwser in database' do
        response = InterpretService.new('create', {
          'question-original': question,
          'answer-original': answer,
          'hashtags-original': hashtags
        })

        expect(Faq.last.question).to match question
        expect(Faq.last.answer).to match answer
      end

      it 'hashtags are created' do
        response = InterpretService.new('create', {
          'question-original': question,
          'answer-original': answer,
          'hashtags-original': hashtags
        })

        expect(hashtags.split(/[\s,]+/).first).to match Hashtag.first.name
        expect(hashtags.split(/[\s,]+/).last).to match Hashtag.last.name
      end
    end
  end

  describe '#remove' do
    let(:faq) { create(:faq, company: company) }

    context 'with valid ID' do
      it 'remove the faq' do
        response = InterpretService.call('remove', { :id => faq.id })

        expect(response).to match("Deletado com sucesso")
      end
    end

    context 'with invalid ID' do
      it 'receive the error message' do
        response = InterpretService.call('remove', { :id => rand(1..100) })

        expect(response).to match("Questão inválida, verifique o Id")
      end
    end
  end
end
