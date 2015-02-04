# coding: utf-8
require "spec_helper"

module Xiami
  describe Song do
    it { should respond_to :name }
    it { should respond_to :artist }
    it { should respond_to :album }

    it { should respond_to :title }
    it { should respond_to :artist_name }
    it { should respond_to :album_name }

    describe '#fetch' do
      it 'parses data' do
        song = Song.fetch('http://www.xiami.com/song/1773357685')

        song.temporary_url.should == 'http://m5.file.xiami.com/516/37516/705574889/1773357685_15603838_l.mp3?auth_key=33b783883a2ffa9e9df48e5dd456ebad-1415232000-0-null'

        song.name.should == 'Escape (The Pina Colada Song)'
        song.title.should == 'Escape (The Pina Colada Song)'
        song.artist_name.should == 'Rupert Holmes'
        song.album_name.should == 'Guardians of the Galaxy'

        song.album.id.should == 705574889
        song.album.name.should == 'Guardians of the Galaxy'
        song.album.cover_url.should == 'http://img.xiami.net/images/album/img16/37516/7055748891405574890_4.jpg'

        song.artist.id.should == 37516
        song.artist.name.should == 'Rupert Holmes'
      end

      it 'accepts song id as well' do
        song = Song.fetch('1773357685')

        song.album.id.should == 705574889
      end

      context 'when content contains html' do
        it 'unescapes' do
          song = Song.fetch(1242697)
          song.album.name.should == "(What's the Story) Morning Glory?"
        end
      end

      context 'when parsing xml fails' do
        it 'parses html' do
          song = Song.fetch(376054)
          song.name.should == '她的睫毛'
          song.id.should == 376054
          song.album.id.should == 6650
          song.album.name.should == '叶惠美'
          song.album.cover_url.should == 'http://img.xiami.net/images/album/img60/1260/66501387132591_4.jpg'
          song.artist.id.should == 1260
          song.artist.name.should == '周杰伦'
        end

        context 'with song id 1770769001' do
          it 'pass' do
            song = Song.fetch(1770769001)
            song.artist.id.should == nil
            song.artist.name.should == '梁博'
          end
        end

        context 'with song id 15914' do
          it 'pass' do
            song = Song.fetch(15914)
            song.artist.id.should == 521
            song.artist.name.should == '李嘉强'
            song.album.cover_urls.count.should == 4
            song.album.cover_url.should == 'http://img.xiami.net/images/pic/04/04/10123658079m_2.jpg'
          end
        end
      end
    end

    describe '#==' do
      let(:song1) { Song.new.tap { |song| song.id = '123' } }
      let(:song2) { Song.new.tap { |song| song.id = '123' } }
      let(:song3) { Song.new.tap { |song| song.id = '1234' } }
      let(:song4) { Song.new.tap { |song| song.id = nil } }

      it 'test equality base on id' do
        song1.should == song2
        song2.should_not == song3
        song1.should_not == nil
        song1.should_not == song4
      end
    end
  end
end
