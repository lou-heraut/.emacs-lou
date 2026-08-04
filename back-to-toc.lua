function Header(el)
  if el.level <= 3 then
    local link = pandoc.RawInline("html", ' <a href="#TOC" class="back-to-toc">↑</a>')
    table.insert(el.content, link)
  end
  return el
end