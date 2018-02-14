require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    context 'with zero faqs' do
      it 'don\'t find message' do
        response = InterpretService.call('list', {})
        expect(response).to match('Nada encontrado')
      end
    end

    context 'with two faqs' do
      it 'find questions and answer in response' do
        faq1 = create(:faq, company: @company)
        faq2 = create(:faq, company: @company)

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
      it 'don\'t find message' do
        response = InterpretService.call('search', {'query': ''})
        expect(response).to match('Nada encontrado')
      end
    end

    context 'with valid query' do
      it 'find question and answer in response' do
        faq = create(:faq, company: @company)

        response = InterpretService.call('search', {'query' => faq.question.split(' ').sample})

        expect(response).to match(faq.question)
        expect(response).to match(faq.answer)
      end
    end
  end

  describe '#search by category' do
    context 'with invalid hashtag' do
      it 'return don\'t find message' do
        response = InterpretService.call('search_by_hashtag', {'query': ''})
        expect(response).to match('Nada encontrado')
      end
    end

    context 'with valid hashtag' do
      it 'find question and answer in response' do
        faq = create(:faq, company: @company)
        hashtag = create(:hashtag, company: @company)
        create(:faq_hashtag, faq: faq, hashtag: hashtag)

        response = InterpretService.call('search_by_hashtag', {'query' => hashtag.name})

        expect(response).to match(faq.question)
        expect(response).to match(faq.answer)
      end
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hashtags = '#{FFaker::Lorem.word}, #{FFaker::Lorem.word}'
    end

    context 'without hashtag params' do
      it 'receive a error' do
        response = InterpretService.call('create', {'question-original' => @question, 'answer-original' => @answer})
        expect(response).to match('Hashtag Obrigatória')
      end
    end

    context 'with valid params' do
      it 'receive success message' do
        response = InterpretService.call('create', {'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags})
        expect(response).to match('Criado com sucesso')
      end

      it 'find question and anwser in database' do
        response = InterpretService.call('create', {'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags})
        expect(Faq.last.question).to match(@question)
        expect(Faq.last.answer).to match(@answer)
      end

      it 'hashtags are created' do
        response = InterpretService.call('create', {'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags})
        expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
        expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
      end
    end
  end

  describe '#remove' do
    context 'with valid ID' do
      it 'remove Faq' do
        faq = create(:faq, company: @company)
        response = InterpretService.call('remove', {'id' => faq.id})
        expect(response).to match('Deletado com sucesso')
      end
    end

    context 'with invalid ID' do
      it 'receive error message' do
        response = InterpretService.call('remove', {'id' => rand(1..9999)})
        expect(response).to match('Questão inválida, verifique o Id')
      end
    end
  end
end