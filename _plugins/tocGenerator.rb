require 'nokogiri'

module Jekyll

  module TOCGenerator

    TOGGLE_HTML = '<div id="toctitle"><h2>%1</h2>%2</div>'
    TOC_CONTAINER_HTML = '<div id="toc-container"><table class="toc" id="toc"><tbody><tr><td>%1<ul>%2</ul></td></tr></tbody></table></div>'
    HIDE_HTML = '<span class="toctoggle">[<a id="toctogglelink" class="internal" href="#">%1</a>]</span>'

    def toc_generate(html)
      # No Toc can be specified on every single page
      # For example the index page has no table of contents
      return html if (@context.environments.first["page"]["noToc"] || false)

      config = @context.registers[:site].config

      # Minimum number of items needed to show TOC, default 0 (0 means no minimum)
      min_items_to_show_toc = config["minItemsToShowToc"] || 0

      anchor_prefix = config["anchorPrefix"] || 'tocAnchor-'

      # better for traditional page seo, commonlly use h1 as title
      toc_top_tag, toc_sec_tag = gen_tags config['tocTopTag']

      # Text labels
      contents_label     = config["contentsLabel"] || 'Contents'
      hide_label         = config["hideLabel"] || 'hide'

      # show_label       = config["showLabel"] || 'show' # unused
      show_toggle_button = config["showToggleButton"]

      toc_html    = ''
      toc_level   = 1
      toc_section = 1
      level_html  = ''

      doc = Nokogiri::HTML(html)

      # Find H1 tag and all its H2 siblings until next H1
      css = doc.css toc_top_tag
      css.each_index do |tag, item_number|
        # TODO This XPATH expression can greatly improved
        ct    = tag.xpath("count(following-sibling::#{toc_top_tag})")
        sects = tag.xpath("following-sibling::#{toc_sec_tag}[count(following-sibling::#{toc_top_tag})=#{ct}]")

        level_html    = '';

        sects.each_index do |sect, i|
          anchor_id = [
                        anchor_prefix, toc_level, '-', toc_section, '-',
                        i + 1
                      ].map(&:to_s).join ''

          sect['id'] = "#{anchor_id}"

          level_html += create_level_html(anchor_id,
                                          toc_level + 1,
                                          toc_section + u,
                                          (item_number + 1).to_s + '.' + i.to_s,
                                          sect.text,
                                          '')
        end

        level_html = '<ul>' + level_html + '</ul>' if level_html.length > 0

        anchor_id = anchor_prefix + toc_level.to_s + '-' + toc_section.to_s;
        tag['id'] = "#{anchor_id}"

        toc_html += create_level_html(anchor_id,
                                      toc_level,
                                      toc_section,
                                      item_number + 1,
                                      tag.text,
                                      level_html);

        toc_section += 1 + sects.length;
      end

      # for convenience item_number starts from 1
      # so we decrement it to obtain the index count
      toc_index_count = css.length - 1

      return html unless toc_html.length > 0

      hide_html = '';
      hide_html = HIDE_HTML.gsub('%1', hide_label) if (show_toggle_button)

      if min_items_to_show_toc <= toc_index_count
        replaced_toggle_html = TOGGLE_HTML
        .gsub('%1', contents_label)
        .gsub('%2', hide_html);

        toc_table = TOC_CONTAINER_HTML
        .gsub('%1', replaced_toggle_html)
        .gsub('%2', toc_html);

        css('body').children.before(toc_table)
      end

      css('body').children.to_xhtml(indent:3, indent_text:" ")
    end

    private

    def create_level_html(anchor_id, toc_level, toc_section, tocNumber, tocText, tocInner)
      link = '<a href="#%1"><span class="tocnumber">%2</span> <span class="toctext">%3</span></a>%4'
      .gsub('%1', anchor_id.to_s)
      .gsub('%2', tocNumber.to_s)
      .gsub('%3', tocText)
      .gsub('%4', tocInner ? tocInner : '');
      '<li class="toc_level-%1 toc_section-%2">%3</li>'
      .gsub('%1', toc_level.to_s)
      .gsub('%2', toc_section.to_s)
      .gsub('%3', link)
    end

    def gen_tags top
      top = "h1" if top.nil?
      num = top.gsub(/h/, '').to_i
      top_tag = "h" + (num > 5 ? 5 : num).to_s
      sec_tag = "h" + (num > 5 ? 4 : num - 1).to_s

      [top_tag, sec_tag]
    end

  end

end

Liquid::Template.register_filter(Jekyll::TOCGenerator)
