class Compresser
  STARTING_DICT_SIZE = 256

  def build_dictionary
    Hash[ Array.new(STARTING_DICT_SIZE) {|i| [i.chr, i.chr]} ]
  end

  def compress(file)
    text = File.read(file)
    dict_size = STARTING_DICT_SIZE
    dictionary = build_dictionary

    word = ""
    result = []
    text.split("").each do |char|
      check_word = word + char
      if dictionary.has_key?(check_word)
        word = check_word
      else
        result << dictionary[word]
        dictionary[check_word] = dict_size
        dict_size += 1
        word = char
      end
    end
    result << dictionary[word] unless word.empty?
    result.to_s.gsub("\"", "").gsub("\\n", "\n")
  end

  def decompress(file)
    text = parse_compressed_file(File.read(file))
    dict_size = STARTING_DICT_SIZE
    dictionary = build_dictionary

    word = result = text.shift
    text.each do |seq|
      if dictionary.has_key?(seq)
        entry = dictionary[seq]
      elsif seq == dict_size
        entry = word + word[0,1]
      else
        raise "Bad compression: #{seq}"
      end
      result += entry

      dictionary[dict_size] = word + entry[0,1]
      dict_size += 1

      word = entry
    end
    result
  end

  def parse_compressed_file(string)
    match = /\[((.(,\s)*)+)\]/.match(string)[1]
    match.split(", ")
  end
end
