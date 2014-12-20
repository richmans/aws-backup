module AwsBackup
  class ConsolePrinter
    include Singleton
    def initialize
      @header_size = 50
      @header_color = :blue
      @io = $stdout
    end

    def print(text, options={})
      text += "\n" unless options[:newline] == false
      text = text.color(options[:color]) unless options[:color].nil?
      @io.print "#{text}"
    end

    def line
      @io.puts '=' * @header_size
    end

    def ask(question)
      question += ': '
      print question, :newline => false
      $stdin.gets
    end

    def print_header(header_text)
      header_text = " [ #{header_text} ] "
      text_size = header_text.size
      return header_text if header_text.size >= @header_size
      header_text = header_text.color(@header_color)
      left_padding = right_padding = (@header_size - text_size) / 2
      left_padding += 1 if text_size.odd?
      header = '=' * left_padding + header_text + '=' * right_padding
      puts header
    end
  end
end
