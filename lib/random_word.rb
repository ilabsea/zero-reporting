class RandomWord
  def self.child_word_from_file(file)
    content = File.open(file){|f| f.read}.split
    child_word_from_string(content )
  end

  def self.child_word_from_string(content)
    word_index = rand(content.size - 1) 
    word = content[word_index]
    "#{rand(9)}#{rand(9)}#{rand(9)}#{word}#{rand(9)}#{rand(9)}#{rand(9)}"
  end
end