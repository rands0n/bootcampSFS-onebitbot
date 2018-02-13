require_relative '../../spec_helper'

describe FaqModule::CreateService do
  let(:company) { create :company }
  let(:question) { FFaker::Lorem.sentence }
  let(:answer) { FFaker::Lorem.sentence }
  let(:hashtags) { '#{FFaker::Lorem.word}, #{FFaker::Lorem.word}' }

  describe '#call' do
    context 'without a hashtag params' do
      let(:create_service) { described_class.new({
        'question-original' => question,
        'answer-original' => answer
      }) }

      it 'will receive an error' do
        respose = create_service.call

        expect(response).to match 'Hashtag Obrigatória'
      end
    end

    context 'with valid params' do
      let(:create_service) { described_class.new({
        'question-original' => question,
        'answer-original' => answer,
        'hashtags-original' => hashtags
      }) }

      it 'receive success message' do
        response = create_service.call

        expect(response).to match('Criado com sucesso')
      end

      it 'find the question and anwser in database' do
        response = create_service.call

        expect(Faq.last.question).to match question
        expect(Faq.last.anwser).to match anwser
      end

      it 'hashtags are created' do
        response = create_service.call

        expect(hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
        expect(hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
      end
    end
  end
end
