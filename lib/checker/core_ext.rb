class CoreExt
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split("::")
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

  def self.classify(underscored_word)
    words = underscored_word.split("_")
    words.each(&:capitalize!).join("")
  end

  def self.underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!(/::/, "/")
    word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end

class String
  def constantize
    CoreExt.constantize(self)
  end

  def classify
    CoreExt.classify(self)
  end

  def underscore
    CoreExt.underscore(self)
  end

  def ends_with?(patt)
    patt = Regexp.new(Regexp.escape(patt) + "$")
    match patt
  end
end

class Array
  def all_true?
    all? { |o| o == true }
  end
end
