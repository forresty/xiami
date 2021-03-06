require "nokogiri"

module Xiami
  module Parser
    class SongSearchHTMLParser
      def initialize(html_content)
        @html_content = html_content
      end

      def parse
        result = []

        doc = Nokogiri::HTML(@html_content)

        doc.at_css('table.track_list').css('td.chkbox').each do |checkbox|
          tr = checkbox.parent

          next if tr.parent['class'] == 'same_song_group'

          title = tr.at_css('td.song_name').css('a').find { |a| a['target'] == '_blank' }['title']
          artist = tr.at_css('td.song_artist a').text.strip
          album = tr.at_css('td.song_album a').text
          id = checkbox.at_css('input')['value'].to_i

          result << { id: id, title: title, artist: artist, album: album }
        end

        result
      end

      module ClassMethods
        def parse(html_content)
          new(html_content).parse
        end
      end

      class << self
        include ClassMethods
      end
    end
  end
end
