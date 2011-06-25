module Refinery
  class PagePart < ActiveRecord::Base

    attr_accessible :title, :content, :position, :body, :created_at,
                    :updated_at, :refinery_page_id
    belongs_to :page, :class_name => '::Refinery::Page', :foreign_key => :refinery_page_id

    validates :title, :presence => true
    alias_attribute :content, :body

    translates :body if respond_to?(:translates)

    def to_param
      "page_part_#{title.downcase.gsub(/\W/, '_')}"
    end

    before_save :normalise_text_fields
    if defined?(::PagePart::Translation)
      ::Refinery::PagePart::Translation.module_eval do
        attr_accessible :locale
      end
    end
  protected
    def normalise_text_fields
      unless body.blank? or body =~ /^\</
        self.body = "<p>#{body.gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>"
      end
    end
    #generate a title_symbol from title
    def to_title_symbol
      title.to_s.gsub(/\ /, '').underscore.to_sym  
    end
    
    #generate a section hash , can override with any option
    def to_section(options={})
      {:fallback=>part.body}.update(options)
    end
  end
end
