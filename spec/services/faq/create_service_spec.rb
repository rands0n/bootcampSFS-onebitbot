require_relative '../../spec_helper'

describe FaqModule::CreateService do
  let(:company) { create :company }
  let(:question) { FFaker::Lorem.sentence }
  let(:answer) { FFaker::Lorem.sentence }
  let(:hashtags) { '#{FFaker::Lorem.word}, #{FFaker::Lorem.word}' }

  describe '#call' do
    context 'without a hashtag params' do
      it 'will receive an error' do
        response = FaqModule::CreateService.new({
          'question-original' => question,
          'answer-original' => answer
        }).call

        expect(response).to match 'Hashtag Obrigatória'
      end
    end

    context 'with valid params' do
      it 'receive success message' do
        response = FaqModule::CreateService.new({
          'question-original' => question,
          'answer-original' => answer,
          'hashtags-original' => hashtags
        }).call

        expect(response).to match('Criado com sucesso')
      end

      it 'find the question and answer in database' do
        response = FaqModule::CreateService.new({
          'question-original' => question,
          'answer-original' => answer,
          'hashtags-original' => hashtags
        }).call

        expect(Faq.last.question).to match question
        expect(Faq.last.answer).to match answer
      end

      it 'hashtags are created' do
        response = FaqModule::CreateService.new({
          'question-original' => question,
          'answer-original' => answer,
          'hashtags-original' => hashtags
        }).call

        expect(hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
        expect(hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
      end
    end
  end
end
