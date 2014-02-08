module Jekyll
  class Youtube < Liquid::Tag
  	Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/  

    def initialize(name, markup, tokens)
      @height = '100%'
	  @width = '100%'

	  if markup =~ Syntax
      	@id = $1;
      	@width = $3 unless $3.nil?
      	@height = $4 unless $4.nil?
      end      
      super
    end

    def render(context)
      # %(<div class="embed-video-container"><iframe width='#{@width}' height='#{@height}' src="http://www.youtube.com/embed/#{@id}" frameborder="0" allowfullscreen></iframe></div>)
      %(<div class="embed-video-container"><iframe width='#{@width}' height='#{@height}' src="http://www.youtube.com/embed/#{@id}" frameborder="0" allowfullscreen></iframe></div>)
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::Youtube)