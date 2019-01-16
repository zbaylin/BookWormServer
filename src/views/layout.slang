html lang="en"
  head
    meta charset="utf-8"

    title BookWorm
    link rel="stylesheet" href="/css/spectre.min.css"
    link rel="stylesheet" href="/css/main.css"

  body
    == content          
    - components.each do |component|
      script type="text/javascript" src="/js/#{component}.js"