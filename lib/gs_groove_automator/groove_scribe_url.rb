require "uri"

module GrooveScribeURL
  def uri_parser
    return @uri_parser if defined? @uri_parser
    @uri_parser = URI::Parser.new
  end

  def url_encode(encodee)
    return "" if encodee.nil? or encodee.strip.empty?
    uri_parser.escape(encodee)
  end

  def URL
    "http://localhost:8080/?" +
      "TimeSig=#{@time_signature.name}&" +
      "Div=#{@subdivisions}&" +
      "Title=#{url_encode(@title)}&" +
      "Author=#{url_encode(@author)}&" +
      "Comments=#{url_encode(@comments)}&" +
      "Tempo=#{@tempo}&" +
      "Measures=#{@total_measures}&" +
      "H=#{@measures[:hh]}&" +
      "S=#{@measures[:sd]}&" +
      "K=#{@measures[:kd]}"
  end
end
