require_relative './../spec_helper'

describe HelpService do
  describe '#call' do
    it 'response have the main commands' do
      response = HelpService.call

      expect(response).to match('help')
      expect(response).to match('Adicione ao Faq')
      expect(response).to match('Remova ID')
      expect(response).to match('O que você sabe sobre X')
      expect(response).to match('Pesquise a hashtag X')
      expect(response).to match('Perguntas e Respostas')
    end
  end
end